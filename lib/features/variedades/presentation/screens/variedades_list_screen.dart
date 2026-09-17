import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/ui/navigation/app_status_tab_bar.dart';
import '../../../../core/ui/feedback/change_status_dialog.dart';
import '../../../app_shell/presentation/widgets/app_scaffold.dart';
import '../../../../core/ui/sheets/app_bottom_sheet.dart';
import '../../../../core/ui/states/empty_state.dart';
import '../../domain/entities/variedad.dart';
import '../viewmodels/variedades_viewmodel.dart';
import '../widgets/variedad_card.dart';
import 'variedades_form_screen.dart';

class VariedadListScreen extends StatefulWidget {
  const VariedadListScreen({super.key});

  @override
  State<VariedadListScreen> createState() => _VariedadListScreenState();
}

class _VariedadListScreenState extends State<VariedadListScreen> {
  StatusSummaryValue _statusFilter = StatusSummaryValue.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<VariedadViewModel>().load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VariedadViewModel>();

    final activeCount = vm.items.where((e) => e.estado).length;
    final inactiveCount = vm.items.length - activeCount;

    final filteredItems = switch (_statusFilter) {
      StatusSummaryValue.all => vm.items,
      StatusSummaryValue.active => vm.items.where((e) => e.estado).toList(),
      StatusSummaryValue.inactive => vm.items.where((e) => !e.estado).toList(),
    };

    return AppScaffold(
      title: Text('Variedades'),
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
                  message: 'Aún no tienes variedades registradas.',
                  actionLabel: 'Reintentar',
                  onAction: vm.load,
                );
              }

              if (filteredItems.isEmpty) {
                return EmptyState(
                  message: _statusFilter == StatusSummaryValue.active
                      ? 'No tienes variedades activas.'
                      : 'No tienes variedades inactivas.',
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
                    ...filteredItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: VariedadCard(
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

  Future<void> _openForm(BuildContext context, {Variedad? item}) async {
    await AppBottomSheet.show(
      context: context,
      title: item == null ? 'Nueva variedad' : 'Editar variedad',
      initialChildSize: 0.3,
      maxChildSize: 0.5,
      builder: (context, controller) => SingleChildScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.all(20),
        child: VariedadFormScreen(item: item),
      ),
    );
  }

  Future<void> _confirmChangeStatus(BuildContext context, Variedad item) async {
    if (item.id == null) return;

    final vm = context.read<VariedadViewModel>();

    await ChangeStatusDialog.showAndAction(
      context: context,
      currentStatus: item.estado,
      article: 'La',
      entityName: 'Variedad',
      itemName: item.nombre,
      onConfirm: (newStatus) =>
          vm.changeStatus(id: item.id!, estado: newStatus),
      getErrorMessage: () => vm.errorMessage,
    );
  }
}
