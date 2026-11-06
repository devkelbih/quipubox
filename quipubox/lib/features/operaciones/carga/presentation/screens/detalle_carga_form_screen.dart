import '../../domain/entities/detalle_carga.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../core/ui/feedback/app_toast.dart';
import '../../../../../core/ui/states/empty_state.dart';
import '../../../../../core/network/connectivity_viewmodel.dart';
import '../viewmodels/detalle_carga_form_viewmodel.dart';
import '../widgets/detalle_destino_directo_fields.dart';

class DetalleCargaFormScreen extends StatefulWidget {
  final int operacionId;
  final DetalleCarga? item;
  const DetalleCargaFormScreen({
    super.key,
    required this.operacionId,
    this.item,
  });

  @override
  State<DetalleCargaFormScreen> createState() => _DetalleCargaFormScreenState();
}

class _DetalleCargaFormScreenState extends State<DetalleCargaFormScreen> {
  final _cantidad = TextEditingController();
  final _instrucciones = TextEditingController();
  final _observaciones = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cantidad.text = widget.item?.cantidadJabas.toString() ?? '';
    _instrucciones.text = widget.item?.instruccionReparto ?? '';
    _observaciones.text = widget.item?.observaciones ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DetalleCargaFormViewModel>().load(
          widget.operacionId,
          item: widget.item,
        );
      }
    });
  }

  @override
  void dispose() {
    _cantidad.dispose();
    _instrucciones.dispose();
    _observaciones.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final vm = context.read<DetalleCargaFormViewModel>();
    final saved = await vm.save(
      operacionId: widget.operacionId,
      cantidad: _cantidad.text,
      instrucciones: _instrucciones.text,
      observaciones: _observaciones.text,
    );
    if (!mounted) return;
    AppToast.show(
      saved
          ? widget.item == null
                ? 'Detalle de carga registrado correctamente.'
                : 'Detalle de carga actualizado correctamente.'
          : vm.errorMessage ?? 'No se pudo registrar el detalle.',
      type: saved ? ToastType.success : ToastType.error,
    );
    if (saved) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DetalleCargaFormViewModel>();
    final online = context.watch<ConnectivityViewModel>().isOnline;
    return PopScope(
      canPop: !vm.isSaving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.item == null
                ? 'Nuevo detalle de carga'
                : 'Editar detalle de carga',
          ),
        ),
        body: SafeArea(
          top: false,
          child: vm.isLoading || !vm.loaded && vm.errorMessage == null
              ? const Center(child: CircularProgressIndicator())
              : !vm.loaded
              ? Center(
                  child: EmptyState(
                    message:
                        vm.errorMessage ??
                        'No se pudieron cargar los catálogos.',
                    actionLabel: 'Reintentar',
                    onAction: () =>
                        vm.load(widget.operacionId, item: widget.item),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    DropdownButtonFormField<int>(
                      initialValue: vm.idEmisor,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Cliente emisor',
                      ),
                      items: [
                        for (final item in vm.emisoresDisponibles)
                          DropdownMenuItem(
                            value: item.id,
                            child: Text(
                              item.nombreCompleto,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: vm.isSaving
                          ? null
                          : (value) => vm.updateSelection(emisor: value),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      initialValue: vm.idFruta,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Fruta'),
                      items: [
                        for (final item in vm.frutas)
                          DropdownMenuItem(
                            value: item.id,
                            child: Text(
                              item.nombre,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: vm.isSaving ? null : vm.selectFruta,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int?>(
                      key: ValueKey('variedad-${vm.idFruta}'),
                      initialValue: vm.idVariedad,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Variedad (opcional)',
                      ),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('Sin variedad'),
                        ),
                        for (final item in vm.variedadesDisponibles)
                          DropdownMenuItem<int?>(
                            value: item.id,
                            child: Text(
                              item.nombre,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: vm.isSaving || vm.idFruta == null
                          ? null
                          : vm.selectVariedad,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      initialValue: vm.idTipoJaba,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de jaba',
                      ),
                      items: [
                        for (final item in vm.tiposJaba)
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
                          : (value) => vm.updateSelection(tipoJaba: value),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _cantidad,
                      enabled: !vm.isSaving,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Cantidad de jabas',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Distribuir después (reparto)'),
                      subtitle: const Text(
                        'El receptor y el puesto se asignan posteriormente en reparto.',
                      ),
                      value: vm.esReparto,
                      onChanged: vm.isSaving || widget.item != null
                          ? null
                          : vm.setReparto,
                    ),
                    if (!vm.esReparto && widget.item == null)
                      const DetalleDestinoDirectoFields(),
                    if (widget.item != null)
                      const Text(
                        'La modalidad, el receptor y el puesto se conservan al editar.',
                      ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _instrucciones,
                      enabled: !vm.isSaving,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText:
                            'Instrucciones de reparto o entrega (opcional)',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _observaciones,
                      enabled: !vm.isSaving,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Observaciones (opcional)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Requiere retorno de jabas'),
                      value: vm.requiereRetorno,
                      onChanged: vm.isSaving ? null : vm.setRetorno,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: vm.isSaving || !online ? null : _save,
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
                            : widget.item == null
                            ? 'Registrar detalle'
                            : 'Guardar cambios',
                      ),
                    ),
                    if (!online)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          'Se requiere conexión a internet para guardar.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
