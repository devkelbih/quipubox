import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/ui/app_toast.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../data/models/sede_request_model.dart';
import '../../domain/entities/sede.dart';
import '../viewmodels/sedes_viewmodel.dart';
class SedeFormScreen extends StatefulWidget { final Sede? item; const SedeFormScreen({super.key, this.item}); @override State<SedeFormScreen> createState() => _SedeFormScreenState(); }
class _SedeFormScreenState extends State<SedeFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final tipoSedeController = TextEditingController();
  final direccionController = TextEditingController();
  final ciudadController = TextEditingController();
  final departamentoController = TextEditingController();
  @override void initState() { super.initState(); if (widget.item != null) { nombreController.text = widget.item!.nombre.toString();
      tipoSedeController.text = widget.item!.tipoSede.toString();
      direccionController.text = widget.item!.direccion.toString();
      ciudadController.text = widget.item!.ciudad.toString();
      departamentoController.text = widget.item!.departamento.toString(); } }
  @override void dispose() { nombreController.dispose();
    tipoSedeController.dispose();
    direccionController.dispose();
    ciudadController.dispose();
    departamentoController.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) { final vm = context.watch<SedeViewModel>(); return AlertDialog(title: Text(widget.item == null ? 'Nuevo registro' : 'Editar registro'), content: SizedBox(width: 420, child: SingleChildScrollView(child: Form(key: formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [TextFormField(controller: nombreController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Nombre'), validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,), const SizedBox(height: 12),
TextFormField(controller: tipoSedeController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Tipo de sede'), validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,), const SizedBox(height: 12),
TextFormField(controller: direccionController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Dirección'), ), const SizedBox(height: 12),
TextFormField(controller: ciudadController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Ciudad'), ), const SizedBox(height: 12),
TextFormField(controller: departamentoController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Departamento'), ), const SizedBox(height: 12), if (vm.errorMessage != null) Text(vm.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error))])))), actions: [TextButton(onPressed: vm.isSaving ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')), FilledButton(onPressed: vm.isSaving ? null : _save, child: vm.isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Guardar'))]); }
  Future<void> _save() async { if (!formKey.currentState!.validate()) return; final request = SedeRequestModel(idEmpresa: widget.item == null ? context.read<AuthViewModel>().currentCompanyId : null, nombre: nombreController.text.trim(), tipoSede: tipoSedeController.text.trim(), direccion: direccionController.text.trim().isEmpty ? null : direccionController.text.trim(), ciudad: ciudadController.text.trim().isEmpty ? null : ciudadController.text.trim(), departamento: departamentoController.text.trim().isEmpty ? null : departamentoController.text.trim()); final ok = await context.read<SedeViewModel>().save(id: widget.item?.id, request: request); if (!mounted) return; if (ok) { Navigator.of(context).pop(); AppToast.show('Guardado correctamente.', type: ToastType.success); } else { AppToast.show(context.read<SedeViewModel>().errorMessage ?? 'No se pudo guardar.', type: ToastType.error); } }
}
