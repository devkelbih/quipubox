import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/ui/navigation/app_status_tab_bar.dart';
import '../../../../core/ui/feedback/change_status_dialog.dart';
import '../../../app_shell/presentation/widgets/app_scaffold.dart';
import '../../../../core/ui/sheets/app_bottom_sheet.dart';
import '../../../../core/ui/states/empty_state.dart';
import '../../domain/entities/fruta.dart';
import '../viewmodels/frutas_viewmodel.dart';
import '../widgets/fruta_card.dart';
import 'frutas_form_screen.dart';

class FrutaListScreen extends StatefulWidget {
  const FrutaListScreen({super.key});

  @override
  State<FrutaListScreen> createState() => _FrutaListScreenState();
}

class _FrutaListScreenState extends State<FrutaListScreen> {
  StatusSummaryValue _statusFilter = StatusSummaryValue.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<FrutaViewModel>().load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FrutaViewModel>();

    final activeCount = vm.items.where((e) => e.estado).length;
    final inactiveCount = vm.items.length - activeCount;

    final filteredItems = switch (_statusFilter) {
      StatusSummaryValue.all => vm.items,
      StatusSummaryValue.active => vm.items.where((e) => e.estado).toList(),
      StatusSummaryValue.inactive => vm.items.where((e) => !e.estado).toList(),
    };

    return AppScaffold(
      title: Text('Frutas'),
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
                  message: 'Aún no tienes frutas registradas.',
                  actionLabel: 'Reintentar',
                  onAction: vm.load,
                );
              }

              if (filteredItems.isEmpty) {
                return EmptyState(
                  message: _statusFilter == StatusSummaryValue.active
                      ? 'No tienes frutas activas.'
                      : 'No tienes frutas inactivas.',
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
                        child: FrutaCard(
                          item: item,
                          onEdit: () => _openForm(context, item: item),
                          onChangeStatus: () =>
                              _confirmChangeStatus(context, item),
                          onViewVariedades: () =>
                              _showVariedades(context, item),
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

  Future<void> _openForm(BuildContext context, {Fruta? item}) async {
    await AppBottomSheet.show(
      context: context,
      title: item == null ? 'Nueva fruta' : 'Editar fruta',
      initialChildSize: 0.40,
      maxChildSize: 0.45,
      builder: (context, controller) => SingleChildScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ), // Permite deslizar si el contenido no cabe en ese 45%
        padding: const EdgeInsets.all(20),
        child: FrutaFormScreen(item: item),
      ),
    );
  }

  Future<void> _showVariedades(BuildContext context, Fruta item) async {
    await AppBottomSheet.show(
      context: context,
      title: 'Variedades de ${item.nombre}',
      initialChildSize: 0.30,
      maxChildSize: 0.4,
      builder: (context, controller) {
        final variedades = item.variedades ?? [];

        if (variedades.isEmpty) {
          return const Center(child: Text('No hay variedades disponibles.'));
        }

        return ListView.separated(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ), // Garantiza el scroll si hay muchas variedades
          itemCount: variedades.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final variedad = variedades[index];
            return ListTile(
              leading: const Icon(Icons.grain_rounded),
              title: Text(variedad.nombre),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmChangeStatus(BuildContext context, Fruta item) async {
    if (item.id == null) return;
    final vm = context.read<FrutaViewModel>();

    await ChangeStatusDialog.showAndAction(
      context: context,
      currentStatus: item.estado,
      article: 'La',
      entityName: 'Fruta',
      itemName: item.nombre,
      onConfirm: (newStatus) =>
          vm.changeStatus(id: item.id!, estado: newStatus),
      getErrorMessage: () => vm.errorMessage,
    );
  }
}
