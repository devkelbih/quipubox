import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/connectivity_viewmodel.dart';
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
  final _formKey = GlobalKey<FormState>();

  final _placaController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _observacionesController = TextEditingController();

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();

    final item = widget.item;

    if (item != null) {
      _placaController.text = item.placa;
      _descripcionController.text = item.descripcion ?? '';
      _observacionesController.text = item.observaciones ?? '';
    }
  }

  @override
  void dispose() {
    _placaController.dispose();
    _descripcionController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CamionViewModel>();
    final connectivity = context.watch<ConnectivityViewModel>();

    final canSubmit = !vm.isSaving && connectivity.isOnline;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _placaController,
            enabled: !vm.isSaving,
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
            controller: _descripcionController,
            enabled: !vm.isSaving,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              prefixIcon: Icon(Icons.local_shipping_rounded),
            ),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _observacionesController,
            enabled: !vm.isSaving,
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

          if (!connectivity.isOnline) ...[
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

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: vm.isSaving
                      ? null
                      : () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: canSubmit ? _save : null,
                  child: vm.isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _isEditing
                              ? 'Guardar cambios'
                              : 'Registrar camión',
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final item = widget.item;

    final camion = Camion(
      id: item?.id,
      idEmpresa: item?.idEmpresa,
      estado: item?.estado ?? true,
      placa: _placaController.text.trim().toUpperCase(),
      descripcion: _emptyToNull(_descripcionController.text),
      observaciones: _emptyToNull(_observacionesController.text),
    );

    final vm = context.read<CamionViewModel>();

    final ok = _isEditing
        ? await vm.update(camion)
        : await vm.create(camion);

    if (!mounted) return;

    AppToast.show(
      ok
          ? _isEditing
              ? 'Camión actualizado correctamente.'
              : 'Camión registrado correctamente.'
          : vm.errorMessage ?? 'No se pudo guardar el camión.',
      type: ok ? ToastType.success : ToastType.error,
    );

    if (ok) {
      Navigator.pop(context);
    }
  }

  String? _emptyToNull(String value) {
    final text = value.trim();
    return text.isEmpty ? null : text;
  }
}