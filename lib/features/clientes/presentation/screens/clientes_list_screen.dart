import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:quipubox/core/navigation/app_routes.dart';
import 'package:quipubox/core/ui/feedback/change_status_dialog.dart';
import 'package:quipubox/core/ui/navigation/app_status_tab_bar.dart';
import 'package:quipubox/core/ui/states/empty_state.dart';
import 'package:quipubox/features/clientes/domain/entities/cliente.dart';
import 'package:quipubox/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:quipubox/features/clientes/presentation/widgets/cliente_card.dart';

import '../../../app_shell/presentation/widgets/app_scaffold.dart';

class ClienteListScreen extends StatefulWidget {
  const ClienteListScreen({super.key});

  @override
  State<ClienteListScreen> createState() => _ClienteListScreenState();
}

class _ClienteListScreenState extends State<ClienteListScreen> {
  StatusSummaryValue _statusFilter = StatusSummaryValue.all;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClienteViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClienteViewModel>();

    final activeCount = vm.items.where((e) => e.estado).length;
    final inactiveCount = vm.items.length - activeCount;

    final filteredItems = switch (_statusFilter) {
      StatusSummaryValue.all => vm.items,
      StatusSummaryValue.active =>
        vm.items.where((e) => e.estado).toList(),
      StatusSummaryValue.inactive =>
        vm.items.where((e) => !e.estado).toList(),
    };

    return AppScaffold(
      title: const Text('Clientes'),
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
          if (vm.isSaving || vm.isChangingStatus)
            const LinearProgressIndicator(),

          Expanded(
            child: () {
              if (vm.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
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
                  message: 'Aún no tienes clientes registrados.',
                  actionLabel: 'Reintentar',
                  onAction: vm.load,
                );
              }

              if (filteredItems.isEmpty) {
                return EmptyState(
                  message: _statusFilter == StatusSummaryValue.active
                      ? 'No tienes clientes activos.'
                      : 'No tienes clientes inactivos.',
                  actionLabel: 'Mostrar todos',
                  onAction: () {
                    setState(
                      () => _statusFilter = StatusSummaryValue.all,
                    );
                  },
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
                        child: ClienteCard(
                          item: item,
                          onEdit: () => _openForm(
                            context,
                            item: item,
                          ),
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

  Future<void> _openForm(
    BuildContext context, {
    Cliente? item,
  }) async {
    context.push(
      AppRoutes.clientesForm,
      extra: item,
    );
  }

  Future<void> _confirmChangeStatus(
    BuildContext context,
    Cliente item,
  ) async {
    if (item.id == null) return;

    final vm = context.read<ClienteViewModel>();

    await ChangeStatusDialog.showAndAction(
      context: context,
      currentStatus: item.estado,
      article: 'El',
      entityName: 'Cliente',
      itemName: item.nombreCompleto,
      onConfirm: (newStatus) => vm.changeStatus(
        id: item.id!,
        estado: newStatus,
      ),
      getErrorMessage: () => vm.errorMessage,
    );
  }
}