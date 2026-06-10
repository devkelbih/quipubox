import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/ui/app_toast.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../data/models/puesto_request_model.dart';
import '../../domain/entities/puesto.dart';
import '../viewmodels/puestos_viewmodel.dart';
class PuestoFormScreen extends StatefulWidget { final Puesto? item; const PuestoFormScreen({super.key, this.item}); @override State<PuestoFormScreen> createState() => _PuestoFormScreenState(); }
class _PuestoFormScreenState extends State<PuestoFormScreen> {
  final formKey = GlobalKey<FormState>();
  final idLugarController = TextEditingController();
  final numeroPuestoController = TextEditingController();
  final referenciaController = TextEditingController();
  @override void initState() { super.initState(); if (widget.item != null) { idLugarController.text = widget.item!.idLugar.toString();
      numeroPuestoController.text = widget.item!.numeroPuesto.toString();
      referenciaController.text = widget.item!.referencia.toString(); } }
  @override void dispose() { idLugarController.dispose();
    numeroPuestoController.dispose();
    referenciaController.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) { final vm = context.watch<PuestoViewModel>(); return AlertDialog(title: Text(widget.item == null ? 'Nuevo registro' : 'Editar registro'), content: SizedBox(width: 420, child: SingleChildScrollView(child: Form(key: formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [TextFormField(controller: idLugarController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'ID lugar operativo'), validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,), const SizedBox(height: 12),
TextFormField(controller: numeroPuestoController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Número de puesto'), validator: (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,), const SizedBox(height: 12),
TextFormField(controller: referenciaController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Referencia'), ), const SizedBox(height: 12), if (vm.errorMessage != null) Text(vm.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error))])))), actions: [TextButton(onPressed: vm.isSaving ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')), FilledButton(onPressed: vm.isSaving ? null : _save, child: vm.isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Guardar'))]); }
  Future<void> _save() async { if (!formKey.currentState!.validate()) return; final request = PuestoRequestModel(idEmpresa: widget.item == null ? context.read<AuthViewModel>().currentCompanyId : null, idLugar: int.tryParse(idLugarController.text.trim()) ?? 0, numeroPuesto: numeroPuestoController.text.trim(), referencia: referenciaController.text.trim().isEmpty ? null : referenciaController.text.trim()); final ok = await context.read<PuestoViewModel>().save(id: widget.item?.id, request: request); if (!mounted) return; if (ok) { Navigator.of(context).pop(); AppToast.show('Guardado correctamente.', type: ToastType.success); } else { AppToast.show(context.read<PuestoViewModel>().errorMessage ?? 'No se pudo guardar.', type: ToastType.error); } }
}
