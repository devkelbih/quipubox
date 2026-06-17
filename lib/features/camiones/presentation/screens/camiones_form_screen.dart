import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/ui/feedback/app_toast.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../data/models/camion_request_model.dart';
import '../../domain/entities/camion.dart';
import '../viewmodels/camiones_viewmodel.dart';
class CamionFormScreen extends StatefulWidget { final Camion? item; const CamionFormScreen({super.key, this.item}); @override State<CamionFormScreen> createState() => _CamionFormScreenState(); }
class _CamionFormScreenState extends State<CamionFormScreen> {
  final formKey = GlobalKey<FormState>();
  final placaController = TextEditingController();
  final descripcionController = TextEditingController();
  final observacionesController = TextEditingController();
  @override void initState() { super.initState(); if (widget.item != null) { placaController.text = widget.item!.placa.toString();
      descripcionController.text = widget.item!.descripcion.toString();
      observacionesController.text = widget.item!.observaciones.toString(); } }
  @override void dispose() { placaController.dispose();
    descripcionController.dispose();
    observacionesController.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) { final vm = context.watch<CamionViewModel>(); return AlertDialog(title: Text(widget.item == null ? 'Nuevo registro' : 'Editar registro'), content: SizedBox(width: 420, child: SingleChildScrollView(child: Form(key: formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [TextFormField(controller: placaController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Placa'), validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,), const SizedBox(height: 12),
TextFormField(controller: descripcionController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Descripción'), ), const SizedBox(height: 12),
TextFormField(controller: observacionesController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Observaciones'), ), const SizedBox(height: 12), if (vm.errorMessage != null) Text(vm.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error))])))), actions: [TextButton(onPressed: vm.isSaving ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')), FilledButton(onPressed: vm.isSaving ? null : _save, child: vm.isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Guardar'))]); }
  Future<void> _save() async { if (!formKey.currentState!.validate()) return; final request = CamionRequestModel(idEmpresa: widget.item == null ? context.read<AuthViewModel>().currentCompanyId : null, placa: placaController.text.trim(), descripcion: descripcionController.text.trim().isEmpty ? null : descripcionController.text.trim(), observaciones: observacionesController.text.trim().isEmpty ? null : observacionesController.text.trim()); final ok = await context.read<CamionViewModel>().save(id: widget.item?.id, request: request); if (!mounted) return; if (ok) { Navigator.of(context).pop(); AppToast.show('Guardado correctamente.', type: ToastType.success); } else { AppToast.show(context.read<CamionViewModel>().errorMessage ?? 'No se pudo guardar.', type: ToastType.error); } }
}
