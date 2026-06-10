import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/ui/app_toast.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../data/models/usuario_request_model.dart';
import '../../domain/entities/usuario.dart';
import '../viewmodels/usuarios_viewmodel.dart';
class UsuarioFormScreen extends StatefulWidget { final Usuario? item; const UsuarioFormScreen({super.key, this.item}); @override State<UsuarioFormScreen> createState() => _UsuarioFormScreenState(); }
class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  final formKey = GlobalKey<FormState>();
  final idSedeController = TextEditingController();
  final nombresController = TextEditingController();
  final apellidosController = TextEditingController();
  final telefonoController = TextEditingController();
  final emailController = TextEditingController();
  @override void initState() { super.initState(); if (widget.item != null) { idSedeController.text = widget.item!.idSede.toString();
      nombresController.text = widget.item!.nombres.toString();
      apellidosController.text = widget.item!.apellidos.toString();
      telefonoController.text = widget.item!.telefono.toString();
      emailController.text = widget.item!.email.toString(); } }
  @override void dispose() { idSedeController.dispose();
    nombresController.dispose();
    apellidosController.dispose();
    telefonoController.dispose();
    emailController.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) { final vm = context.watch<UsuarioViewModel>(); return AlertDialog(title: Text(widget.item == null ? 'Nuevo registro' : 'Editar registro'), content: SizedBox(width: 420, child: SingleChildScrollView(child: Form(key: formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [TextFormField(controller: idSedeController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'ID sede'), validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,), const SizedBox(height: 12),
TextFormField(controller: nombresController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Nombres'), validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,), const SizedBox(height: 12),
TextFormField(controller: apellidosController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Apellidos'), validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,), const SizedBox(height: 12),
TextFormField(controller: telefonoController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Teléfono'), ), const SizedBox(height: 12),
TextFormField(controller: emailController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Email'), validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,), const SizedBox(height: 12), if (vm.errorMessage != null) Text(vm.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error))])))), actions: [TextButton(onPressed: vm.isSaving ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')), FilledButton(onPressed: vm.isSaving ? null : _save, child: vm.isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Guardar'))]); }
  Future<void> _save() async { if (!formKey.currentState!.validate()) return; final request = UsuarioRequestModel(idEmpresa: widget.item == null ? context.read<AuthViewModel>().currentCompanyId : null, idSede: int.tryParse(idSedeController.text.trim()) ?? 0, nombres: nombresController.text.trim(), apellidos: apellidosController.text.trim(), telefono: telefonoController.text.trim().isEmpty ? null : telefonoController.text.trim(), email: emailController.text.trim()); final ok = await context.read<UsuarioViewModel>().save(id: widget.item?.id, request: request); if (!mounted) return; if (ok) { Navigator.of(context).pop(); AppToast.show('Guardado correctamente.', type: ToastType.success); } else { AppToast.show(context.read<UsuarioViewModel>().errorMessage ?? 'No se pudo guardar.', type: ToastType.error); } }
}
