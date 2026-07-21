import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/ui/navigation/app_status_tab_bar.dart';

import '../../../../core/ui/feedback/app_toast.dart';
import '../../../../core/ui/feedback/change_status_dialog.dart';
import '../../../app_shell/presentation/widgets/app_scaffold.dart';
import '../../../../core/ui/sheets/app_form_sheet.dart';
import '../../../../core/ui/states/empty_state.dart';
import '../../domain/entities/sede.dart';
import '../viewmodels/sedes_viewmodel.dart';
import '../widgets/sede_card.dart';
import 'sedes_form_screen.dart';

class SedeListScreen extends StatefulWidget {
  const SedeListScreen({super.key});

  @override
  State<SedeListScreen> createState() => _SedeListScreenState();
}

class _SedeListScreenState extends State<SedeListScreen> {
  StatusSummaryValue _statusFilter = StatusSummaryValue.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<SedeViewModel>().load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SedeViewModel>();

    final activeCount = vm.items.where((e) => e.estado).length;
    final inactiveCount = vm.items.length - activeCount;

    final filteredItems = switch (_statusFilter) {
      StatusSummaryValue.all => vm.items,
      StatusSummaryValue.active => vm.items.where((e) => e.estado).toList(),
      StatusSummaryValue.inactive => vm.items.where((e) => !e.estado).toList(),
    };

    return AppScaffold(
      title: 'Sedes',
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
          if (vm.isSaving || vm.isDeleting) const LinearProgressIndicator(),
          Expanded(
            child: () {
              if (vm.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (vm.errorMessage != null && vm.items.isEmpty) {
                return EmptyState(vm.errorMessage!);
              }

              if (vm.items.isEmpty) {
                return const EmptyState('Aún no tienes sedes registradas.');
              }

              return RefreshIndicator(
                onRefresh: vm.load,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...filteredItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SedeCard(
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

  Future<void> _openForm(BuildContext context, {Sede? item}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: context.read<SedeViewModel>(),
          child: AppFormSheet(
            title: item == null ? 'Nueva sede' : 'Editar sede',
            child: SedeFormScreen(item: item),
          ),
        );
      },
    );
  }

  Future<void> _confirmChangeStatus(BuildContext context, Sede item) async {
    final newStatus = !item.estado;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return ChangeStatusDialog(
          newStatus: newStatus,
          title: newStatus ? 'Activar sede' : 'Desactivar sede',
          message: newStatus
              ? 'La sede "${item.nombre}" volverá a estar disponible para nuevas operaciones.'
              : 'La sede "${item.nombre}" dejará de estar disponible para nuevas operaciones.',
          confirmText: newStatus ? 'Activar' : 'Desactivar',
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final id = item.id;

    if (id == null) {
      AppToast.show('No se encontró el ID de la sede.', type: ToastType.error);
      return;
    }

    final viewModel = context.read<SedeViewModel>();

    final ok = await viewModel.changeStatus(id: id, estado: newStatus);

    if (!context.mounted) return;

    AppToast.show(
      ok
          ? newStatus
                ? 'Sede activada correctamente.'
                : 'Sede desactivada correctamente.'
          : viewModel.errorMessage ??
                (newStatus
                    ? 'No se pudo activar la sede.'
                    : 'No se pudo desactivar la sede.'),
      type: ok ? ToastType.success : ToastType.error,
    );
  }
}

