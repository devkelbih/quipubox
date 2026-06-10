import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/ui/app_toast.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../data/models/cliente_request_model.dart';
import '../../domain/entities/cliente.dart';
import '../viewmodels/clientes_viewmodel.dart';
class ClienteFormScreen extends StatefulWidget { final Cliente? item; const ClienteFormScreen({super.key, this.item}); @override State<ClienteFormScreen> createState() => _ClienteFormScreenState(); }
class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nombresController = TextEditingController();
  final apellidosController = TextEditingController();
  final apodoController = TextEditingController();
  final telefonoController = TextEditingController();
  final observacionesController = TextEditingController();
  @override void initState() { super.initState(); if (widget.item != null) { nombresController.text = widget.item!.nombres.toString();
      apellidosController.text = widget.item!.apellidos.toString();
      apodoController.text = widget.item!.apodo.toString();
      telefonoController.text = widget.item!.telefono.toString();
      observacionesController.text = widget.item!.observaciones.toString(); } }
  @override void dispose() { nombresController.dispose();
    apellidosController.dispose();
    apodoController.dispose();
    telefonoController.dispose();
    observacionesController.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) { final vm = context.watch<ClienteViewModel>(); return AlertDialog(title: Text(widget.item == null ? 'Nuevo registro' : 'Editar registro'), content: SizedBox(width: 420, child: SingleChildScrollView(child: Form(key: formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [TextFormField(controller: nombresController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Nombres'), validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,), const SizedBox(height: 12),
TextFormField(controller: apellidosController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Apellidos'), ), const SizedBox(height: 12),
TextFormField(controller: apodoController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Apodo'), ), const SizedBox(height: 12),
TextFormField(controller: telefonoController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Teléfono'), validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,), const SizedBox(height: 12),
TextFormField(controller: observacionesController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Observaciones'), ), const SizedBox(height: 12), if (vm.errorMessage != null) Text(vm.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error))])))), actions: [TextButton(onPressed: vm.isSaving ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')), FilledButton(onPressed: vm.isSaving ? null : _save, child: vm.isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Guardar'))]); }
  Future<void> _save() async { if (!formKey.currentState!.validate()) return; final request = ClienteRequestModel(idEmpresa: widget.item == null ? context.read<AuthViewModel>().currentCompanyId : null, nombres: nombresController.text.trim(), apellidos: apellidosController.text.trim().isEmpty ? null : apellidosController.text.trim(), apodo: apodoController.text.trim().isEmpty ? null : apodoController.text.trim(), telefono: telefonoController.text.trim(), observaciones: observacionesController.text.trim().isEmpty ? null : observacionesController.text.trim()); final ok = await context.read<ClienteViewModel>().save(id: widget.item?.id, request: request); if (!mounted) return; if (ok) { Navigator.of(context).pop(); AppToast.show('Guardado correctamente.', type: ToastType.success); } else { AppToast.show(context.read<ClienteViewModel>().errorMessage ?? 'No se pudo guardar.', type: ToastType.error); } }
}
