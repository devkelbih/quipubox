import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/ui/app_toast.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../data/models/tipos_jaba_request_model.dart';
import '../../domain/entities/tipos_jaba.dart';
import '../viewmodels/tipos_jaba_viewmodel.dart';
class TipoJabaFormScreen extends StatefulWidget { final TipoJaba? item; const TipoJabaFormScreen({super.key, this.item}); @override State<TipoJabaFormScreen> createState() => _TipoJabaFormScreenState(); }
class _TipoJabaFormScreenState extends State<TipoJabaFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final tipoMaterialController = TextEditingController();
  final descripcionController = TextEditingController();
  @override void initState() { super.initState(); if (widget.item != null) { nombreController.text = widget.item!.nombre.toString();
      tipoMaterialController.text = widget.item!.tipoMaterial.toString();
      descripcionController.text = widget.item!.descripcion.toString(); } }
  @override void dispose() { nombreController.dispose();
    tipoMaterialController.dispose();
    descripcionController.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) { final vm = context.watch<TipoJabaViewModel>(); return AlertDialog(title: Text(widget.item == null ? 'Nuevo registro' : 'Editar registro'), content: SizedBox(width: 420, child: SingleChildScrollView(child: Form(key: formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [TextFormField(controller: nombreController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Nombre'), validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,), const SizedBox(height: 12),
TextFormField(controller: tipoMaterialController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Material'), validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,), const SizedBox(height: 12),
TextFormField(controller: descripcionController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Descripción'), ), const SizedBox(height: 12), if (vm.errorMessage != null) Text(vm.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error))])))), actions: [TextButton(onPressed: vm.isSaving ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')), FilledButton(onPressed: vm.isSaving ? null : _save, child: vm.isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Guardar'))]); }
  Future<void> _save() async { if (!formKey.currentState!.validate()) return; final request = TipoJabaRequestModel(idEmpresa: widget.item == null ? context.read<AuthViewModel>().currentCompanyId : null, nombre: nombreController.text.trim(), tipoMaterial: tipoMaterialController.text.trim(), descripcion: descripcionController.text.trim().isEmpty ? null : descripcionController.text.trim()); final ok = await context.read<TipoJabaViewModel>().save(id: widget.item?.id, request: request); if (!mounted) return; if (ok) { Navigator.of(context).pop(); AppToast.show('Guardado correctamente.', type: ToastType.success); } else { AppToast.show(context.read<TipoJabaViewModel>().errorMessage ?? 'No se pudo guardar.', type: ToastType.error); } }
}
