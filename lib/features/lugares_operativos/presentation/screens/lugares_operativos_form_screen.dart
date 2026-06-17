import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/ui/feedback/app_toast.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../data/models/lugar_operativo_request_model.dart';
import '../../domain/entities/lugar_operativo.dart';
import '../viewmodels/lugares_operativos_viewmodel.dart';

class LugarOperativoFormScreen extends StatefulWidget {
  final LugarOperativo? item;
  const LugarOperativoFormScreen({super.key, this.item});
  @override
  State<LugarOperativoFormScreen> createState() =>
      _LugarOperativoFormScreenState();
}

class _LugarOperativoFormScreenState extends State<LugarOperativoFormScreen> {
  final formKey = GlobalKey<FormState>();
  final idSedeController = TextEditingController();
  final nombreController = TextEditingController();
  final direccionReferenciaController = TextEditingController();
  final observacionesController = TextEditingController();
  final tipoLugarController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      idSedeController.text = widget.item!.idSede.toString();
      nombreController.text = widget.item!.nombre.toString();
      direccionReferenciaController.text = widget.item!.direccionReferencia
          .toString();
      observacionesController.text = widget.item!.observaciones.toString();
      tipoLugarController.text = widget.item!.tipoLugar.toString();
    }
  }

  @override
  void dispose() {
    idSedeController.dispose();
    nombreController.dispose();
    direccionReferenciaController.dispose();
    observacionesController.dispose();
    tipoLugarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LugarOperativoViewModel>();
    return AlertDialog(
      title: Text(widget.item == null ? 'Nuevo registro' : 'Editar registro'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: idSedeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'ID sede'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Campo obligatorio'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nombreController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Campo obligatorio'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: direccionReferenciaController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Dirección o referencia',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: observacionesController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'Observaciones'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: tipoLugarController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'Tipo de lugar'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Campo obligatorio'
                      : null,
                ),
                const SizedBox(height: 12),
                if (vm.errorMessage != null)
                  Text(
                    vm.errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: vm.isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: vm.isSaving ? null : _save,
          child: vm.isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }

Future<void> _save() async {
  if (!formKey.currentState!.validate()) return;

  final idEmpresa = context.read<AuthViewModel>().currentCompanyId;

  if (idEmpresa == null) {
    AppToast.show(
      'No se pudo obtener la empresa del usuario logueado.',
      type: ToastType.error,
    );
    return;
  }

  final request = LugarOperativoRequestModel(
    idEmpresa: idEmpresa,
    idSede: int.tryParse(idSedeController.text.trim()) ?? 0,
    nombre: nombreController.text.trim(),
    direccionReferencia: direccionReferenciaController.text.trim().isEmpty
        ? null
        : direccionReferenciaController.text.trim(),
    observaciones: observacionesController.text.trim().isEmpty
        ? null
        : observacionesController.text.trim(),
    tipoLugar: tipoLugarController.text.trim(),
  );

  final ok = await context.read<LugarOperativoViewModel>().save(
        id: widget.item?.id,
        request: request,
      );

  if (!mounted) return;

  if (ok) {
    Navigator.of(context).pop();
    AppToast.show('Guardado correctamente.', type: ToastType.success);
  } else {
    AppToast.show(
      context.read<LugarOperativoViewModel>().errorMessage ??
          'No se pudo guardar.',
      type: ToastType.error,
    );
  }
}
}
