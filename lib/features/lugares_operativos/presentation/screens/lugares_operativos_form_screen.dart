import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/connectivity_viewmodel.dart';
import '../../../../core/ui/feedback/app_toast.dart';
import '../../../sedes/domain/entities/sede.dart';
import '../../../sedes/presentation/viewmodels/sedes_viewmodel.dart';
import '../../domain/entities/lugar_operativo.dart';
import '../../domain/enums/lugar_operativo_tipos.dart';
import '../viewmodels/lugares_operativos_viewmodel.dart';

class LugarOperativoFormScreen extends StatefulWidget {
  final LugarOperativo? item;

  const LugarOperativoFormScreen({super.key, this.item});

  @override
  State<LugarOperativoFormScreen> createState() =>
      _LugarOperativoFormScreenState();
}

class _LugarOperativoFormScreenState extends State<LugarOperativoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _direccionController;
  late final TextEditingController _observacionesController;

  late LugarOperativoTipos _tipoLugar;

  /// ID de la sede seleccionada.
  ///
  /// El formulario trabaja con el FK directamente.
  int? _idSedeSeleccionada;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();

    final item = widget.item;

    _nombreController = TextEditingController(text: item?.nombre ?? '');

    _direccionController = TextEditingController(
      text: item?.direccionReferencia ?? '',
    );

    _observacionesController = TextEditingController(
      text: item?.observaciones ?? '',
    );

    _tipoLugar = item?.tipoLugar ?? LugarOperativoTipos.almacen;

    // El formulario conserva el FK, no la instancia de Sede.
    _idSedeSeleccionada = item?.idSede;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LugarOperativoViewModel>();
    final sedesVm = context.watch<SedeViewModel>();
    final isOnline = context.watch<ConnectivityViewModel>().isOnline;

    final canSubmit = !vm.isSaving && isOnline;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nombreController,
            enabled: !vm.isSaving,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nombre del lugar',
              hintText: 'Ej. Mercado Mayorista',
              prefixIcon: Icon(Icons.place_rounded),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa el nombre del lugar';
              }

              return null;
            },
          ),
          const SizedBox(height: 14),

          DropdownButtonFormField<int>(
            initialValue: _idSedeSeleccionada,
            decoration: const InputDecoration(
              labelText: 'Sede',
              prefixIcon: Icon(Icons.apartment_rounded),
            ),
            items: sedesVm.items.where((sede) => sede.id != null).map((sede) {
              return DropdownMenuItem<int>(
                value: sede.id!,
                child: Text(sede.nombre.trim()),
              );
            }).toList(),
            onChanged: vm.isSaving || sedesVm.isLoading
                ? null
                : (value) {
                    setState(() {
                      _idSedeSeleccionada = value;
                    });
                  },
            validator: (value) {
              if (value == null) {
                return 'Selecciona una sede';
              }

              return null;
            },
          ),
          const SizedBox(height: 14),

          DropdownButtonFormField<LugarOperativoTipos>(
            initialValue: _tipoLugar,
            decoration: const InputDecoration(
              labelText: 'Tipo de lugar',
              prefixIcon: Icon(Icons.category_rounded),
            ),
            items: LugarOperativoTipos.values.map((tipo) {
              return DropdownMenuItem<LugarOperativoTipos>(
                value: tipo,
                child: Text(tipo.label),
              );
            }).toList(),
            onChanged: vm.isSaving
                ? null
                : (value) {
                    if (value == null) return;

                    setState(() {
                      _tipoLugar = value;
                    });
                  },
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: _direccionController,
            enabled: !vm.isSaving,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Dirección / referencia',
              hintText: 'Ej. Puerta principal del mercado',
              prefixIcon: Icon(Icons.location_on_rounded),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa una dirección o referencia';
              }

              return null;
            },
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: _observacionesController,
            enabled: !vm.isSaving,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Observaciones',
              hintText: 'Opcional',
              prefixIcon: Icon(Icons.notes_rounded),
            ),
          ),
          const SizedBox(height: 22),

          FilledButton.icon(
            onPressed: canSubmit ? _submit : null,
            icon: vm.isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(_isEditing ? Icons.save_rounded : Icons.add_rounded),
            label: Text(_isEditing ? 'Guardar cambios' : 'Registrar lugar'),
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

    final vm = context.read<LugarOperativoViewModel>();
    final sedesVm = context.read<SedeViewModel>();
    final item = widget.item;

    final idSede = _idSedeSeleccionada;

    if (idSede == null) {
      AppToast.show('Selecciona una sede válida.', type: ToastType.error);
      return;
    }

    // Recuperamos la Sede correspondiente al ID seleccionado.
    // El ID sigue siendo el FK oficial.
    Sede? sede;

    for (final item in sedesVm.items) {
      if (item.id == idSede) {
        sede = item;
        break;
      }
    }

    if (sede == null) {
      AppToast.show(
        'La sede seleccionada ya no está disponible.',
        type: ToastType.error,
      );
      return;
    }

    final lugarOperativo = LugarOperativo(
      id: item?.id,
      idEmpresa: item?.idEmpresa,

      // FK utilizada para crear y actualizar.
      idSede: idSede,

      // Relación enriquecida utilizada para lectura/UI.
      sede: sede,

      estado: item?.estado ?? true,
      nombre: _nombreController.text.trim(),
      tipoLugar: _tipoLugar,
      direccionReferencia: _nullIfEmpty(_direccionController.text),
      observaciones: _nullIfEmpty(_observacionesController.text),
    );

    final ok = _isEditing
        ? await vm.update(lugarOperativo)
        : await vm.create(lugarOperativo);

    if (!mounted) return;

    AppToast.show(
      ok
          ? _isEditing
                ? 'Lugar operativo actualizado correctamente.'
                : 'Lugar operativo registrado correctamente.'
          : vm.errorMessage ?? 'No se pudo guardar el lugar operativo.',
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
