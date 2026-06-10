import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/ui/app_toast.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';
import '../../../../core/ui/widgets/empty_state.dart';
import '../../domain/entities/camion.dart';
import '../viewmodels/camiones_viewmodel.dart';
import 'camiones_form_screen.dart';
class CamionListScreen extends StatefulWidget { const CamionListScreen({super.key}); @override State<CamionListScreen> createState() => _CamionListScreenState(); }
class _CamionListScreenState extends State<CamionListScreen> {
  @override void initState() { super.initState(); WidgetsBinding.instance.addPostFrameCallback((_) => context.read<CamionViewModel>().load()); }
  @override Widget build(BuildContext context) { final vm = context.watch<CamionViewModel>(); return AppScaffold(title: 'Camiones', floatingActionButton: FloatingActionButton.extended(onPressed: () => _openForm(context), icon: const Icon(Icons.add_rounded), label: const Text('Nuevo')), body: Column(children: [if (vm.isSaving || vm.isDeleting) const LinearProgressIndicator(), Expanded(child: Builder(builder: (_) { if (vm.isLoading) return const Center(child: CircularProgressIndicator()); if (vm.errorMessage != null && vm.items.isEmpty) return EmptyState(vm.errorMessage!); if (vm.items.isEmpty) return const EmptyState('No hay registros.'); return RefreshIndicator(onRefresh: vm.load, child: ListView.separated(padding: const EdgeInsets.all(12), itemCount: vm.items.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (_, i) { final item = vm.items[i]; return Card(child: ListTile(title: Text(_title(item), style: const TextStyle(fontWeight: FontWeight.w900)), subtitle: Text(item.estado ? 'Activo' : 'Inactivo'), trailing: PopupMenuButton<String>(onSelected: (value) async { if (value == 'edit') _openForm(context, item: item); if (value == 'delete') { final viewModel = context.read<CamionViewModel>(); final ok = await viewModel.remove(item.id); if (!context.mounted) return; AppToast.show(ok ? 'Registro desactivado correctamente.' : viewModel.errorMessage ?? 'No se pudo desactivar.', type: ok ? ToastType.success : ToastType.error); } }, itemBuilder: (_) => const [PopupMenuItem(value: 'edit', child: Text('Editar')), PopupMenuItem(value: 'delete', child: Text('Desactivar'))]))); })); }))])); }
  String _title(Camion item) => item.placa.toString().isEmpty ? 'Registro #${item.id}' : item.placa.toString();
  Future<void> _openForm(BuildContext context, {Camion? item}) async => showDialog<void>(context: context, barrierDismissible: false, builder: (_) => ChangeNotifierProvider.value(value: context.read<CamionViewModel>(), child: CamionFormScreen(item: item)));
}
