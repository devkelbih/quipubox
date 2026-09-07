import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/navigation/app_routes.dart';
import 'package:quipubox/core/ui/navigation/app_status_tab_bar.dart';
import '../../../../core/ui/feedback/change_status_dialog.dart';
import '../../../../core/ui/states/empty_state.dart';
import '../../../app_shell/presentation/widgets/app_scaffold.dart';
import '../../domain/entities/usuario.dart';
import '../viewmodels/usuarios_viewmodel.dart';
import '../widgets/usuario_card.dart';

class UsuarioListScreen extends StatefulWidget {
  const UsuarioListScreen({super.key});

  @override
  State<UsuarioListScreen> createState() => _UsuarioListScreenState();
}

class _UsuarioListScreenState extends State<UsuarioListScreen> {
  StatusSummaryValue _statusFilter = StatusSummaryValue.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<UsuarioViewModel>().load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UsuarioViewModel>();

    final activeCount = vm.items.where((e) => e.estado).length;
    final inactiveCount = vm.items.length - activeCount;
    final filteredItems = switch (_statusFilter) {
      StatusSummaryValue.all => vm.items,
      StatusSummaryValue.active => vm.items.where((e) => e.estado).toList(),
      StatusSummaryValue.inactive => vm.items.where((e) => !e.estado).toList(),
    };

    return AppScaffold(
      title: Text('Usuarios'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add_rounded),
          onPressed: vm.isSaving ? null : () => _openForm(context),
        ),
      ],
      appBarBottom: AppStatusTabBar(
        total: vm.items.length,
        active: activeCount,
        inactive: inactiveCount,
        selected: _statusFilter,
        onChanged: (value) {
          setState(() => _statusFilter = value);
        },
      ),
      body: Column(
        children: [
          if (vm.isSaving || vm.isDeleting || vm.isChangingStatus)
            const LinearProgressIndicator(),
          Expanded(
            child: () {
              if (vm.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (vm.errorMessage != null && vm.items.isEmpty) {
                return EmptyState(
                  message: vm.errorMessage!,
                  actionLabel: 'Reintentar',
                  onAction: vm.load,
                );
              }

              if (vm.items.isEmpty) {
                return EmptyState(
                  message: 'Aún no tienes usuarios registradas.',
                  actionLabel: 'Reintentar',
                  onAction: vm.load,
                );
              }

              return RefreshIndicator(
                onRefresh: vm.load,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const SizedBox(height: 14),
                    ...filteredItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: UsuarioCard(
                          item: item,
                          onEdit: () => _openForm(context, item: item),
                          onChangeStatus: () =>
                              _confirmChangeStatus(context, item),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }(),
          ),
        ],
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {Usuario? item}) async {
    context.push(
      AppRoutes.usuariosForm, // Se usa la constante limpia
      extra: item,
    );
  }

  Future<void> _confirmChangeStatus(BuildContext context, Usuario item) async {
    if (item.id == null) return;
    final vm = context.read<UsuarioViewModel>();

    await ChangeStatusDialog.showAndAction(
      context: context,
      currentStatus: item.estado,
      article: 'El',
      entityName: 'Usuario',
      itemName: item.nombreCompleto,
      onConfirm: (newStatus) =>
          vm.changeStatus(id: item.id!, estado: newStatus),
      getErrorMessage: () => vm.errorMessage,
    );
  }
}
