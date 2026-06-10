import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';
import '../../../../core/ui/widgets/empty_state.dart';
import '../viewmodels/roles_viewmodel.dart';
class RolesListScreen extends StatefulWidget { const RolesListScreen({super.key}); @override State<RolesListScreen> createState() => _RolesListScreenState(); }
class _RolesListScreenState extends State<RolesListScreen> { @override void initState(){ super.initState(); WidgetsBinding.instance.addPostFrameCallback((_) => context.read<RolesViewModel>().load()); } @override Widget build(BuildContext context){ final vm=context.watch<RolesViewModel>(); return AppScaffold(title:'Roles', body: Builder(builder: (_){ if(vm.isLoading)return const Center(child:CircularProgressIndicator()); if(vm.errorMessage!=null)return EmptyState(vm.errorMessage!); if(vm.items.isEmpty)return const EmptyState('No hay roles.'); return RefreshIndicator(onRefresh: vm.load, child: ListView.separated(padding: const EdgeInsets.all(12), itemCount: vm.items.length, separatorBuilder: (_,__)=>const SizedBox(height:10), itemBuilder: (_,i){ final item=vm.items[i]; return Card(child: ListTile(title: Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.w900)), subtitle: Text(item.descripcion ?? 'Sin descripción'))); })); })); } }
