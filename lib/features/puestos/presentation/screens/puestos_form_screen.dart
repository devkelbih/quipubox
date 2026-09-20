import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/connectivity_viewmodel.dart';
import '../../../../core/ui/feedback/app_toast.dart';
import '../../../lugares_operativos/domain/entities/lugar_operativo.dart';
import '../../../lugares_operativos/presentation/viewmodels/lugares_operativos_viewmodel.dart';
import '../../domain/entities/puesto.dart';
import '../viewmodels/puestos_viewmodel.dart';

class PuestoFormScreen extends StatefulWidget {
  final Puesto? item;

  const PuestoFormScreen({
    super.key,
    this.item,
  });

  @override
  State<PuestoFormScreen> createState() => _PuestoFormScreenState();
}

class _PuestoFormScreenState extends State<PuestoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _numeroPuestoController;
  late final TextEditingController _referenciaController;

  int? _idLugar;
  LugarOperativo? _lugarSeleccionado;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();

    final item = widget.item;

    _numeroPuestoController = TextEditingController(
      text: item?.numeroPuesto ?? '',
    );

    _referenciaController = TextEditingController(
      text: item?.referencia ?? '',
    );

    _idLugar = item?.idLugar;
    _lugarSeleccionado = item?.lugarOperativo;
  }

  @override
  void dispose() {
    _numeroPuestoController.dispose();
    _referenciaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final puestoVm = context.watch<PuestoViewModel>();
    final lugarVm = context.watch<LugarOperativoViewModel>();
    final isOnline = context.watch<ConnectivityViewModel>().isOnline;

    final canSubmit = !puestoVm.isSaving && isOnline;

    final lugaresDisponibles = lugarVm.items.where((lugar) {
      if (lugar.id == null) return false;

      // En edición mantenemos visible el lugar actualmente asignado,
      // aunque esté inactivo.
      return lugar.estado || lugar.id == _idLugar;
    }).toList();

    final lugarSeleccionado =
        _lugarSeleccionado ??
        (_idLugar == null
            ? null
            : lugarVm.items.where((e) => e.id == _idLugar).firstOrNull);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _numeroPuestoController,
            enabled: !puestoVm.isSaving,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Número de puesto',
              hintText: 'Ej. 1',
              prefixIcon: Icon(Icons.storefront_rounded),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa el número del puesto';
              }

              return null;
            },
          ),
          const SizedBox(height: 14),

          DropdownButtonFormField<int>(
            initialValue: lugaresDisponibles.any(
              (lugar) => lugar.id == _idLugar,
            )
                ? _idLugar
                : null,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Lugar operativo',
              prefixIcon: Icon(Icons.place_rounded),
            ),
            hint: const Text('Selecciona un lugar operativo'),
            items: lugaresDisponibles.map((lugar) {
              final sedeNombre = lugar.sede?.nombre.trim() ?? '';

              return DropdownMenuItem<int>(
                value: lugar.id!,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: lugar.nombre.trim(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (sedeNombre.isNotEmpty) ...[
                        const TextSpan(text: '\n'),
                        TextSpan(text: sedeNombre),
                      ],
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: puestoVm.isSaving || lugarVm.isLoading
                ? null
                : (value) {
                    if (value == null) return;

                    final lugar = lugarVm.items
                        .where((e) => e.id == value)
                        .firstOrNull;

                    setState(() {
                      _idLugar = value;
                      _lugarSeleccionado = lugar;
                    });
                  },
            validator: (value) {
              if (value == null) {
                return 'Selecciona un lugar operativo';
              }

              return null;
            },
          ),

          const SizedBox(height: 14),

          TextFormField(
            controller: _referenciaController,
            enabled: !puestoVm.isSaving,
            textCapitalization: TextCapitalization.sentences,
            minLines: 2,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Referencia',
              hintText: 'Opcional',
              prefixIcon: Icon(Icons.notes_rounded),
            ),
          ),

          const SizedBox(height: 22),

          FilledButton.icon(
            onPressed: canSubmit ? _submit : null,
            icon: puestoVm.isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    _isEditing
                        ? Icons.save_rounded
                        : Icons.add_rounded,
                  ),
            label: Text(
              _isEditing
                  ? 'Guardar cambios'
                  : 'Registrar puesto',
            ),
          ),

          if (!isOnline) ...[
            const SizedBox(height: 12),
            Text(
              'Se requiere conexión a internet para guardar.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<PuestoViewModel>();
    final lugarVm = context.read<LugarOperativoViewModel>();
    final item = widget.item;

    final idLugar = _idLugar;

    if (idLugar == null) {
      AppToast.show(
        'Selecciona un lugar operativo.',
        type: ToastType.error,
      );
      return;
    }

    final lugar = _lugarSeleccionado ??
        lugarVm.items.where((e) => e.id == idLugar).firstOrNull;

    if (lugar == null) {
      AppToast.show(
        'El lugar operativo seleccionado ya no está disponible.',
        type: ToastType.error,
      );
      return;
    }

    final puesto = Puesto(
      id: item?.id,
      idEmpresa: item?.idEmpresa,
      idLugar: idLugar,
      lugarOperativo: lugar,
      estado: item?.estado ?? true,
      numeroPuesto: _numeroPuestoController.text.trim(),
      referencia: _nullIfEmpty(_referenciaController.text),
    );

    final ok = _isEditing
        ? await vm.update(puesto)
        : await vm.create(puesto);

    if (!mounted) return;

    AppToast.show(
      ok
          ? _isEditing
              ? 'Puesto actualizado correctamente.'
              : 'Puesto registrado correctamente.'
          : vm.errorMessage ?? 'No se pudo guardar el puesto.',
      type: ok ? ToastType.success : ToastType.error,
    );

    if (ok) {
      Navigator.pop(context);
    }
  }

  String? _nullIfEmpty(String value) {
    final clean = value.trim();

    return clean.isEmpty ? null : clean;
  }
}