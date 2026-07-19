import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/ui/feedback/change_status_dialog.dart';
import 'package:quipubox/core/ui/sheets/app_form_sheet.dart';
import 'package:quipubox/features/variedades/presentation/widgets/variedad_card.dart';

import '../../../../core/ui/feedback/app_toast.dart';
import '../../../../core/ui/filters/status_summary_filter.dart';
import '../../../app_shell/presentation/widgets/app_scaffold.dart';
import '../../../../core/ui/states/empty_state.dart';
import '../../domain/entities/variedad.dart';
import '../viewmodels/variedades_viewmodel.dart';
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
      title: 'Variedades',
      body: Column(
        children: [
          if (vm.isSaving || vm.isDeleting || vm.isChangingStatus)
            const LinearProgressIndicator(),
          Expanded(
            child: Builder(
              builder: (_) {
                if (vm.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (vm.errorMessage != null && vm.items.isEmpty) {
                  return EmptyState(vm.errorMessage!);
                }

                if (vm.items.isEmpty) {
                  return const EmptyState(
                    'Aún no tienes variedades registradas.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: vm.load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    children: [
                      StatusSummaryFilter(
                        total: vm.items.length,
                        active: activeCount,
                        inactive: inactiveCount,
                        selected: _statusFilter,
                        onChanged: (value) {
                          setState(() => _statusFilter = value);
                        },
                      ),
                      const SizedBox(height: 14),
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
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {Variedad? item}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: context.read<VariedadViewModel>(),
          child: AppFormSheet(
            title: item == null ? 'Nueva variedad' : 'Editar variedad',
            child: VariedadFormScreen(item: item),
          ),
        );
      },
    );
  }

  Future<void> _confirmChangeStatus(BuildContext context, Variedad item) async {
    final newStatus = !item.estado;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return ChangeStatusDialog(
          newStatus: newStatus,
          title: newStatus ? 'Activar variedad' : 'Desactivar variedad',
          message: newStatus
              ? 'La variedad "${item.nombre}" volverá a estar disponible para nuevas operaciones.'
              : 'La variedad "${item.nombre}" dejará de estar disponible para nuevas operaciones.',
          confirmText: newStatus ? 'Activar' : 'Desactivar',
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final id = item.id;

    if (id == null) {
      AppToast.show(
        'No se encontró el ID de la variedad.',
        type: ToastType.error,
      );
      return;
    }

    final viewModel = context.read<VariedadViewModel>();
    final ok = await viewModel.changeStatus(id: id, estado: newStatus);

    if (!context.mounted) return;

    AppToast.show(
      ok
          ? newStatus
                ? 'Variedad activada correctamente.'
                : 'Variedad desactivada correctamente.'
          : viewModel.errorMessage ??
                (newStatus
                    ? 'No se pudo activar la variedad.'
                    : 'No se pudo desactivar la variedad.'),
      type: ok ? ToastType.success : ToastType.error,
    );
  }
}
