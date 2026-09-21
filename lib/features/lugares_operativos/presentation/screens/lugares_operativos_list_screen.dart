import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quipubox/core/ui/feedback/change_status_dialog.dart';
import 'package:quipubox/core/ui/navigation/app_status_tab_bar.dart';
import 'package:quipubox/core/ui/sheets/app_bottom_sheet.dart';
import 'package:quipubox/core/ui/states/empty_state.dart';

import 'package:quipubox/features/lugares_operativos/domain/entities/lugar_operativo.dart';
import 'package:quipubox/features/lugares_operativos/presentation/screens/lugares_operativos_form_screen.dart';
import 'package:quipubox/features/lugares_operativos/presentation/viewmodels/lugares_operativos_viewmodel.dart';
import 'package:quipubox/features/lugares_operativos/presentation/widgets/lugar_operativo_card.dart';
import 'package:quipubox/features/sedes/presentation/viewmodels/sedes_viewmodel.dart';

import '../../../app_shell/presentation/widgets/app_scaffold.dart';

class LugarOperativoListScreen extends StatefulWidget {
  const LugarOperativoListScreen({super.key});

  @override
  State<LugarOperativoListScreen> createState() =>
      _LugarOperativoListScreenState();
}

class _LugarOperativoListScreenState extends State<LugarOperativoListScreen> {
  StatusSummaryValue _statusFilter = StatusSummaryValue.all;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LugarOperativoViewModel>().load();
      context.read<SedeViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LugarOperativoViewModel>();

    final activeCount = vm.items.where((e) => e.estado).length;
    final inactiveCount = vm.items.length - activeCount;

    final filteredItems = switch (_statusFilter) {
      StatusSummaryValue.all => vm.items,
      StatusSummaryValue.active => vm.items.where((e) => e.estado).toList(),
      StatusSummaryValue.inactive => vm.items.where((e) => !e.estado).toList(),
    };

    return AppScaffold(
      title: const Text('Lugares operativos'),
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
          if (vm.isChangingStatus) const LinearProgressIndicator(),

          Expanded(
            child: () {
              if (vm.isLoading && vm.items.isEmpty) {
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
                  message: 'Aún no tienes lugares operativos registrados.',
                  actionLabel: 'Reintentar',
                  onAction: vm.load,
                );
              }

              if (filteredItems.isEmpty) {
                return EmptyState(
                  message: _statusFilter == StatusSummaryValue.active
                      ? 'No tienes lugares operativos activos.'
                      : 'No tienes lugares operativos inactivos.',
                  actionLabel: 'Mostrar todos',
                  onAction: () {
                    setState(() => _statusFilter = StatusSummaryValue.all);
                  },
                );
              }

              return RefreshIndicator(
                onRefresh: vm.load,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...filteredItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: LugarOperativoCard(
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

  Future<void> _openForm(BuildContext context, {LugarOperativo? item}) async {
    await AppBottomSheet.show(
      context: context,
      title: item == null ? 'Nuevo lugar operativo' : 'Editar lugar operativo',
      minChildSize: 0.5,
      initialChildSize: 0.65,
      maxChildSize: 0.7,
      builder: (context, controller) => SingleChildScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.all(20),
        child: LugarOperativoFormScreen(item: item),
      ),
    );
  }

  Future<void> _confirmChangeStatus(
    BuildContext context,
    LugarOperativo item,
  ) async {
    if (item.id == null) return;

    final vm = context.read<LugarOperativoViewModel>();

    await ChangeStatusDialog.showAndAction(
      context: context,
      currentStatus: item.estado,
      article: 'El',
      entityName: 'Lugar operativo',
      itemName: item.nombre,
      onConfirm: (newStatus) =>
          vm.changeStatus(id: item.id!, estado: newStatus),
      getErrorMessage: () => vm.errorMessage,
    );
  }
}
