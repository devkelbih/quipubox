import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/connectivity_viewmodel.dart';
import '../../../../core/ui/feedback/app_toast.dart';
import '../../domain/entities/tipos_jaba.dart';
import '../../domain/enums/tipo_material_jaba.dart';
import '../viewmodels/tipos_jaba_viewmodel.dart';

class TipoJabaFormScreen extends StatefulWidget {
  final TipoJaba? item;

  const TipoJabaFormScreen({super.key, this.item});

  @override
  State<TipoJabaFormScreen> createState() => _TipoJabaFormScreenState();
}

class _TipoJabaFormScreenState extends State<TipoJabaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;

  late TipoMaterialJaba _tipoMaterial;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();

    final item = widget.item;

    _nombreController = TextEditingController(text: item?.nombre ?? '');
    _descripcionController = TextEditingController(
      text: item?.descripcion ?? '',
    );

    _tipoMaterial = item?.tipoMaterial ?? TipoMaterialJaba.madera;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TipoJabaViewModel>();
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
              labelText: 'Nombre del tipo de jaba',
              hintText: 'Ej. Pepinera',
              prefixIcon: Icon(Icons.inventory_2_rounded),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa el nombre del tipo de jaba';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          DropdownButtonFormField<TipoMaterialJaba>(
            initialValue: _tipoMaterial,
            decoration: const InputDecoration(
              labelText: 'Material',
              prefixIcon: Icon(Icons.category_rounded),
            ),
            items: TipoMaterialJaba.values.map((tipo) {
              return DropdownMenuItem<TipoMaterialJaba>(
                value: tipo,
                child: Text(tipo.label),
              );
            }).toList(),
            onChanged: vm.isSaving
                ? null
                : (value) {
                    if (value == null) return;
                    setState(() => _tipoMaterial = value);
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
            label: Text(
              _isEditing ? 'Guardar cambios' : 'Registrar tipo de jaba',
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

    final vm = context.read<TipoJabaViewModel>();
    final item = widget.item;

    final tipoJaba = TipoJaba(
      id: item?.id,
      idEmpresa: item?.idEmpresa,
      estado: item?.estado ?? true,
      nombre: _nombreController.text.trim(),
      tipoMaterial: _tipoMaterial,
      descripcion: _nullIfEmpty(_descripcionController.text),
    );

    final ok = _isEditing
        ? await vm.update(tipoJaba)
        : await vm.create(tipoJaba);

    if (!mounted) return;

    AppToast.show(
      ok
          ? _isEditing
                ? 'Tipo de jaba actualizado correctamente.'
                : 'Tipo de jaba registrado correctamente.'
          : vm.errorMessage ?? 'No se pudo guardar el tipo de jaba.',
      type: ok ? ToastType.success : ToastType.error,
    );

    if (ok) Navigator.pop(context);
  }

  String? _nullIfEmpty(String value) {
    final clean = value.trim();
    return clean.isEmpty ? null : clean;
  }
}
