import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/connectivity_viewmodel.dart';
import '../../../../core/ui/feedback/app_toast.dart';
import '../../domain/entities/calidad.dart';
import '../viewmodels/calidades_viewmodel.dart';

class CalidadFormScreen extends StatefulWidget {
  final Calidad? item;

  const CalidadFormScreen({
    super.key,
    this.item,
  });

  @override
  State<CalidadFormScreen> createState() => _CalidadFormScreenState();
}

class _CalidadFormScreenState extends State<CalidadFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();

    final item = widget.item;

    _nombreController = TextEditingController(text: item?.nombre ?? '');
    _descripcionController = TextEditingController(
      text: item?.descripcion ?? '',
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CalidadViewModel>();
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
              labelText: 'Nombre de la calidad',
              hintText: 'Ej. Extra',
              prefixIcon: Icon(Icons.workspace_premium_rounded),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa el nombre de la calidad';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: _descripcionController,
            enabled: !vm.isSaving,
            textCapitalization: TextCapitalization.sentences,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Descripción',
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
            label: Text(_isEditing ? 'Guardar cambios' : 'Registrar calidad'),
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

    final vm = context.read<CalidadViewModel>();
    final item = widget.item;

    final calidad = Calidad(
      id: item?.id,
      idEmpresa: item?.idEmpresa,
      estado: item?.estado ?? true,
      nombre: _nombreController.text.trim(),
      descripcion: _nullIfEmpty(_descripcionController.text),
    );

    final ok = _isEditing ? await vm.update(calidad) : await vm.create(calidad);

    if (!mounted) return;

    AppToast.show(
      ok
          ? _isEditing
              ? 'Calidad actualizada correctamente.'
              : 'Calidad registrada correctamente.'
          : vm.errorMessage ?? 'No se pudo guardar la calidad.',
      type: ok ? ToastType.success : ToastType.error,
    );

    if (ok) Navigator.pop(context);
  }

  String? _nullIfEmpty(String value) {
    final clean = value.trim();
    return clean.isEmpty ? null : clean;
  }
}
