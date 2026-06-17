import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/connectivity_viewmodel.dart';
import '../../../../core/ui/feedback/app_toast.dart';
import '../../domain/entities/sede.dart';
import '../../domain/enums/tipo_sede.dart';
import '../viewmodels/sedes_viewmodel.dart';

class SedeFormScreen extends StatefulWidget {
  final Sede? item;

  const SedeFormScreen({
    super.key,
    this.item,
  });

  @override
  State<SedeFormScreen> createState() => _SedeFormScreenState();
}

class _SedeFormScreenState extends State<SedeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _direccionController;
  late final TextEditingController _ciudadController;
  late final TextEditingController _departamentoController;

  late TipoSede _tipoSede;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();

    final item = widget.item;

    _nombreController = TextEditingController(text: item?.nombre ?? '');
    _direccionController = TextEditingController(text: item?.direccion ?? '');
    _ciudadController = TextEditingController(text: item?.ciudad ?? '');
    _departamentoController = TextEditingController(
      text: item?.departamento ?? '',
    );

    _tipoSede = item?.tipoSede ?? TipoSede.origen;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    _ciudadController.dispose();
    _departamentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SedeViewModel>();
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
              labelText: 'Nombre de la sede',
              hintText: 'Ej. Cañete',
              prefixIcon: Icon(Icons.apartment_rounded),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa el nombre de la sede';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          DropdownButtonFormField<TipoSede>(
            initialValue: _tipoSede,
            decoration: const InputDecoration(
              labelText: 'Tipo de sede',
              prefixIcon: Icon(Icons.swap_horiz_rounded),
            ),
            items: TipoSede.values.map((tipo) {
              return DropdownMenuItem<TipoSede>(
                value: tipo,
                child: Text(tipo.label),
              );
            }).toList(),
            onChanged: vm.isSaving
                ? null
                : (value) {
                    if (value == null) return;
                    setState(() => _tipoSede = value);
                  },
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: _ciudadController,
            enabled: !vm.isSaving,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Ciudad',
              hintText: 'Ej. Cañete',
              prefixIcon: Icon(Icons.location_city_rounded),
            ),
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: _departamentoController,
            enabled: !vm.isSaving,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Departamento',
              hintText: 'Ej. Lima',
              prefixIcon: Icon(Icons.map_rounded),
            ),
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: _direccionController,
            enabled: !vm.isSaving,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Dirección',
              hintText: 'Opcional',
              prefixIcon: Icon(Icons.place_rounded),
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
            label: Text(_isEditing ? 'Guardar cambios' : 'Registrar sede'),
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

    final vm = context.read<SedeViewModel>();
    final item = widget.item;

    final sede = Sede(
      id: item?.id,
      idEmpresa: item?.idEmpresa,
      estado: item?.estado ?? true,
      nombre: _nombreController.text.trim(),
      tipoSede: _tipoSede,
      direccion: _nullIfEmpty(_direccionController.text),
      ciudad: _nullIfEmpty(_ciudadController.text),
      departamento: _nullIfEmpty(_departamentoController.text),
    );

    final ok = _isEditing
        ? await vm.update(sede)
        : await vm.create(sede);

    if (!mounted) return;

    AppToast.show(
      ok
          ? _isEditing
              ? 'Sede actualizada correctamente.'
              : 'Sede registrada correctamente.'
          : vm.errorMessage ?? 'No se pudo guardar la sede.',
      type: ok ? ToastType.success : ToastType.error,
    );

    if (ok) Navigator.pop(context);
  }

  String? _nullIfEmpty(String value) {
    final clean = value.trim();
    return clean.isEmpty ? null : clean;
  }
}