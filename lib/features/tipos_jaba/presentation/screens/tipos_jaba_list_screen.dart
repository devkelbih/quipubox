import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/ui/navigation/app_status_tab_bar.dart';
import '../../../../core/ui/feedback/change_status_dialog.dart';
import '../../../app_shell/presentation/widgets/app_scaffold.dart';
import '../../../../core/ui/sheets/app_bottom_sheet.dart';
import '../../../../core/ui/states/empty_state.dart';
import '../../domain/entities/tipos_jaba.dart';
import '../viewmodels/tipos_jaba_viewmodel.dart';
import '../widgets/tipo_jaba_card.dart';
import 'tipos_jaba_form_screen.dart';

class TipoJabaListScreen extends StatefulWidget {
  const TipoJabaListScreen({super.key});

  @override
  State<TipoJabaListScreen> createState() => _TipoJabaListScreenState();
}

class _TipoJabaListScreenState extends State<TipoJabaListScreen> {
  StatusSummaryValue _statusFilter = StatusSummaryValue.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<TipoJabaViewModel>().load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TipoJabaViewModel>();

    final activeCount = vm.items.where((e) => e.estado).length;
    final inactiveCount = vm.items.length - activeCount;

    final filteredItems = switch (_statusFilter) {
      StatusSummaryValue.all => vm.items,
      StatusSummaryValue.active => vm.items.where((e) => e.estado).toList(),
      StatusSummaryValue.inactive => vm.items.where((e) => !e.estado).toList(),
    };

    return AppScaffold(
      title: Text('Tipos de jaba'),
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
                  message: 'Aún no tienes tipos de jaba registrados.',
                  actionLabel: 'Reintentar',
                  onAction: vm.load,
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
                        child: TipoJabaCard(
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

  Future<void> _openForm(BuildContext context, {TiposJaba? item}) async {
    await AppBottomSheet.show(
      context: context,
      title: item == null ? 'Nuevo tipo de jaba' : 'Editar tipo de jaba',
      initialChildSize: 0.3,
      maxChildSize: 0.5,
      builder: (context, controller) => SingleChildScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.all(20),
        child: TipoJabaFormScreen(item: item),
      ),
    );
  }

  Future<void> _confirmChangeStatus(
    BuildContext context,
    TiposJaba item,
  ) async {
    if (item.id == null) return;

    final vm = context.read<TipoJabaViewModel>();

    await ChangeStatusDialog.showAndAction(
      context: context,
      currentStatus: item.estado,
      article: 'El',
      entityName: 'Tipo de jaba',
      itemName: item.nombre,
      onConfirm: (newStatus) =>
          vm.changeStatus(id: item.id!, estado: newStatus),
      getErrorMessage: () => vm.errorMessage,
    );
  }
}
