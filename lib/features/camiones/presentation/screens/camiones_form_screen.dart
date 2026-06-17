import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/ui/feedback/app_toast.dart';
import '../../domain/entities/camion.dart';
import '../viewmodels/camiones_viewmodel.dart';

class CamionFormScreen extends StatefulWidget {
  final Camion? item;

  const CamionFormScreen({
    super.key,
    this.item,
  });

  @override
  State<CamionFormScreen> createState() => _CamionFormScreenState();
}

class _CamionFormScreenState extends State<CamionFormScreen> {
  final formKey = GlobalKey<FormState>();

  final placaController = TextEditingController();
  final descripcionController = TextEditingController();
  final observacionesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final item = widget.item;

    if (item != null) {
      placaController.text = item.placa;
      descripcionController.text = item.descripcion ?? '';
      observacionesController.text = item.observaciones ?? '';
    }
  }

  @override
  void dispose() {
    placaController.dispose();
    descripcionController.dispose();
    observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CamionViewModel>();

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: placaController,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Placa',
              prefixIcon: Icon(Icons.pin_rounded),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa la placa del camión.';
              }

              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: descripcionController,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              prefixIcon: Icon(Icons.local_shipping_rounded),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: observacionesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Observaciones',
              prefixIcon: Icon(Icons.notes_rounded),
              alignLabelWithHint: true,
            ),
          ),
          if (vm.errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              vm.errorMessage!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: vm.isSaving ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: vm.isSaving ? null : _save,
                  child: vm.isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Guardar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!formKey.currentState!.validate()) return;

    final item = widget.item;

    final camion = Camion(
      id: item?.id ?? 0,
      idEmpresa: item?.idEmpresa ?? 0,
      estado: item?.estado ?? true,
      placa: placaController.text.trim().toUpperCase(),
      descripcion: _emptyToNull(descripcionController.text),
      observaciones: _emptyToNull(observacionesController.text),
    );

    final vm = context.read<CamionViewModel>();

    final ok = item == null
        ? await vm.create(camion)
        : await vm.update(camion);

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context);
      AppToast.show(
        item == null
            ? 'Camión registrado correctamente.'
            : 'Camión actualizado correctamente.',
        type: ToastType.success,
      );
      return;
    }

    AppToast.show(
      vm.errorMessage ?? 'No se pudo guardar el camión.',
      type: ToastType.error,
    );
  }

  String? _emptyToNull(String value) {
    final text = value.trim();
    return text.isEmpty ? null : text;
  }
}