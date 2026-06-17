import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/ui/feedback/app_toast.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../data/models/fruta_request_model.dart';
import '../../domain/entities/fruta.dart';
import '../viewmodels/frutas_viewmodel.dart';
class FrutaFormScreen extends StatefulWidget { final Fruta? item; const FrutaFormScreen({super.key, this.item}); @override State<FrutaFormScreen> createState() => _FrutaFormScreenState(); }
class _FrutaFormScreenState extends State<FrutaFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  @override void initState() { super.initState(); if (widget.item != null) { nombreController.text = widget.item!.nombre.toString();
      descripcionController.text = widget.item!.descripcion.toString(); } }
  @override void dispose() { nombreController.dispose();
    descripcionController.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) { final vm = context.watch<FrutaViewModel>(); return AlertDialog(title: Text(widget.item == null ? 'Nuevo registro' : 'Editar registro'), content: SizedBox(width: 420, child: SingleChildScrollView(child: Form(key: formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [TextFormField(controller: nombreController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Nombre'), validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,), const SizedBox(height: 12),
TextFormField(controller: descripcionController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Descripción'), ), const SizedBox(height: 12), if (vm.errorMessage != null) Text(vm.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error))])))), actions: [TextButton(onPressed: vm.isSaving ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')), FilledButton(onPressed: vm.isSaving ? null : _save, child: vm.isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Guardar'))]); }
  Future<void> _save() async { if (!formKey.currentState!.validate()) return; final request = FrutaRequestModel(idEmpresa: widget.item == null ? context.read<AuthViewModel>().currentCompanyId : null, nombre: nombreController.text.trim(), descripcion: descripcionController.text.trim().isEmpty ? null : descripcionController.text.trim()); final ok = await context.read<FrutaViewModel>().save(id: widget.item?.id, request: request); if (!mounted) return; if (ok) { Navigator.of(context).pop(); AppToast.show('Guardado correctamente.', type: ToastType.success); } else { AppToast.show(context.read<FrutaViewModel>().errorMessage ?? 'No se pudo guardar.', type: ToastType.error); } }
}
