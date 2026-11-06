import '../../../../../core/ui/cards/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../core/ui/feedback/app_toast.dart';
import '../../../../../core/ui/states/empty_state.dart';
import '../viewmodels/detalle_calidad_viewmodel.dart';
import '../../domain/entities/detalle_carga_calidad.dart';

class DetalleCalidadForm extends StatefulWidget {
  final int detalleId;
  final DetalleCargaCalidad? editing;
  final int cantidadTotal;
  final ScrollController scrollController;
  const DetalleCalidadForm({
    super.key,
    required this.detalleId,
    this.editing,
    required this.cantidadTotal,
    required this.scrollController,
  });

  @override
  State<DetalleCalidadForm> createState() => _DetalleCalidadFormState();
}

class _DetalleCalidadFormState extends State<DetalleCalidadForm> {
  final _cantidad = TextEditingController();
  final _precio = TextEditingController();
  int? _idCalidad;
  DetalleCargaCalidad? _editing;

  @override
  void initState() {
    super.initState();
    _editing = widget.editing;
    _idCalidad = _editing?.idCalidad;
    _cantidad.text = _editing?.cantidad.toString() ?? '';
    _precio.text = _editing?.precioUnitario?.toString() ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DetalleCalidadViewModel>().load(widget.detalleId);
      }
    });
  }

  @override
  void dispose() {
    _cantidad.dispose();
    _precio.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final wasEditing = _editing != null;
    final vm = context.read<DetalleCalidadViewModel>();
    final succeeded = await vm.save(
      idCalidad: _idCalidad,
      cantidad: _cantidad.text,
      precio: _precio.text,
      cantidadTotal: widget.cantidadTotal,
      editing: _editing,
    );
    if (!mounted) return;
    if (succeeded) {
      setState(() {
        _idCalidad = null;
        _editing = null;
        _cantidad.clear();
        _precio.clear();
      });
    }
    AppToast.show(
      succeeded
          ? !wasEditing
                ? 'Calidad agregada correctamente.'
                : 'Calidad actualizada correctamente.'
          : vm.errorMessage ?? 'No se pudo agregar la calidad.',
      type: succeeded ? ToastType.success : ToastType.error,
    );
    if (succeeded) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DetalleCalidadViewModel>();
    final disponibles = vm.disponibles;
    final selectedId = disponibles.any((item) => item.id == _idCalidad)
        ? _idCalidad
        : null;
    final cantidadEditada =
        vm.registradas
            .where((c) => _editing != null && c.id == _editing!.id)
            .firstOrNull
            ?.cantidad ??
        0;
    final asignadas = vm.cantidadAsignada - cantidadEditada;
    // Una calidad ya registrada dejó de ser un borrador, incluso durante
    // el frame entre la notificación de guardado y el cierre del panel.
    final yaRegistrada = vm.registradas.any(
      (item) => item.idCalidad == _idCalidad,
    );
    final pendiente = yaRegistrada && _editing == null
        ? 0
        : int.tryParse(_cantidad.text) ?? 0;
    final restantes = (widget.cantidadTotal - asignadas).clamp(
      0,
      widget.cantidadTotal > 0 ? widget.cantidadTotal : 0,
    );
    final excede = pendiente > restantes;
    final progreso = widget.cantidadTotal > 0
        ? ((asignadas + pendiente) / widget.cantidadTotal).clamp(0.0, 1.0)
        : 0.0;
    return PopScope(
      canPop: !vm.isSaving,
      child: ListView(
        controller: widget.scrollController,
        padding: const EdgeInsets.all(24),
        children: [
          if (vm.isLoading || !vm.loaded && vm.errorMessage == null)
            const Center(child: CircularProgressIndicator())
          else if (!vm.loaded)
            EmptyState(
              message:
                  vm.errorMessage ?? 'No se pudieron cargar las calidades.',
              actionLabel: 'Reintentar',
              onAction: () => vm.load(widget.detalleId),
            )
          else ...[
            AppCard(
              header: Text(
                'Resumen de clasificación',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '$asignadas de ${widget.cantidadTotal} jabas clasificadas',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progreso,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                    color: excede ? Theme.of(context).colorScheme.error : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pendiente > 0
                        ? '$pendiente por agregar · ${(restantes - pendiente).clamp(0, restantes)} pendientes'
                        : '$restantes jabas pendientes de clasificar',
                  ),
                  const SizedBox(height: 20),
                  if (vm.registradas.isNotEmpty) ...[
                    Text(
                      'Calidades registradas',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    for (final item in vm.registradas)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${item.nombreCalidad ?? 'Calidad #${item.idCalidad}'}: ${item.cantidad} jabas'
                                '${item.precioUnitario == null ? '' : ' · Precio unitario: ${item.precioUnitario!.toStringAsFixed(2)}'}',
                              ),
                            ),
                            if (item.id != null)
                              IconButton(
                                tooltip: 'Editar calidad',
                                onPressed: vm.isSaving
                                    ? null
                                    : () => setState(() {
                                        _editing = item;
                                        _idCalidad = item.idCalidad;
                                        _cantidad.text = '${item.cantidad}';
                                        _precio.text =
                                            item.precioUnitario?.toString() ??
                                            '';
                                      }),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (restantes > 0 &&
                (disponibles.isNotEmpty || _editing != null)) ...[
              Text(
                _editing == null ? 'Agregar calidad' : 'Editar calidad',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
            ],
            if (restantes == 0)
              const Text(
                'La cantidad cargada ya está completamente clasificada.',
              )
            else if (disponibles.isEmpty && _editing == null)
              const EmptyState(
                message:
                    'No hay más calidades activas disponibles para agregar.',
              )
            else ...[
              if (_editing != null)
                InputDecorator(
                  decoration: const InputDecoration(labelText: 'Calidad'),
                  child: Text(
                    _editing!.nombreCalidad ??
                        'Calidad #${_editing!.idCalidad}',
                  ),
                )
              else
                DropdownButtonFormField<int>(
                  // Reiniciar también el estado del FormField si la opción guardada
                  // deja de estar disponible mientras se cierra el panel.
                  key: ValueKey(selectedId),
                  initialValue: selectedId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Calidad'),
                  items: [
                    for (final item in disponibles)
                      DropdownMenuItem(
                        value: item.id,
                        child: Text(
                          item.nombre,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: vm.isSaving
                      ? null
                      : (value) => setState(() => _idCalidad = value),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: _cantidad,
                onChanged: (_) => setState(() {}),
                enabled: !vm.isSaving,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Cantidad de jabas',
                  prefixIcon: const Icon(Icons.inventory_2_outlined),
                  helperText: 'Puedes agregar hasta $restantes jabas.',
                  errorText: excede
                      ? 'La cantidad supera las $restantes jabas pendientes.'
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _precio,
                enabled: !vm.isSaving,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Precio unitario (opcional)',
                  helperText: 'Déjalo vacío si todavía no tiene precio.',
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: vm.isSaving || excede ? null : _save,
                icon: vm.isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_rounded),
                label: Text(
                  vm.isSaving
                      ? 'Guardando...'
                      : _editing == null
                      ? 'Agregar calidad'
                      : 'Guardar cambios',
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
