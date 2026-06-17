import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/ui/feedback/app_toast.dart';
import '../../../../core/ui/feedback/change_status_dialog.dart';
import '../../../../core/ui/filters/status_summary_filter.dart';
import '../../../../core/ui/layout/app_scaffold.dart';
import '../../../../core/ui/sheets/app_form_sheet.dart';
import '../../../../core/ui/states/empty_state.dart';
import '../../domain/entities/camion.dart';
import '../viewmodels/camiones_viewmodel.dart';
import '../widgets/camion_card.dart';
import 'camiones_form_screen.dart';

class CamionListScreen extends StatefulWidget {
  const CamionListScreen({super.key});

  @override
  State<CamionListScreen> createState() => _CamionListScreenState();
}

class _CamionListScreenState extends State<CamionListScreen> {
  StatusSummaryValue _statusFilter = StatusSummaryValue.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<CamionViewModel>().load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CamionViewModel>();

    final activeCount = vm.items.where((e) => e.estado).length;
    final inactiveCount = vm.items.length - activeCount;

    final filteredItems = switch (_statusFilter) {
      StatusSummaryValue.all => vm.items,
      StatusSummaryValue.active => vm.items.where((e) => e.estado).toList(),
      StatusSummaryValue.inactive => vm.items.where((e) => !e.estado).toList(),
    };

    return AppScaffold(
      title: 'Camiones',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: vm.isSaving ? null : () => _openForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo camión'),
      ),
      body: Column(
        children: [
          if (vm.isSaving || vm.isChangingStatus)
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
                  return const EmptyState('Aún no tienes camiones registrados.');
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
                          child: CamionCard(
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

  Future<void> _openForm(BuildContext context, {Camion? item}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: context.read<CamionViewModel>(),
          child: AppFormSheet(
            title: item == null ? 'Nuevo camión' : 'Editar camión',
            child: CamionFormScreen(item: item),
          ),
        );
      },
    );
  }

  Future<void> _confirmChangeStatus(BuildContext context, Camion item) async {
    final newStatus = !item.estado;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return ChangeStatusDialog(
          newStatus: newStatus,
          title: newStatus ? 'Activar camión' : 'Desactivar camión',
          message: newStatus
              ? 'El camión "${item.placa}" volverá a estar disponible.'
              : 'El camión "${item.placa}" dejará de estar disponible.',
          confirmText: newStatus ? 'Activar' : 'Desactivar',
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final viewModel = context.read<CamionViewModel>();

    final ok = await viewModel.changeStatus(
      id: item.id,
      estado: newStatus,
    );

    if (!context.mounted) return;

    AppToast.show(
      ok
          ? newStatus
              ? 'Camión activado correctamente.'
              : 'Camión desactivado correctamente.'
          : viewModel.errorMessage ??
              (newStatus
                  ? 'No se pudo activar el camión.'
                  : 'No se pudo desactivar el camión.'),
      type: ok ? ToastType.success : ToastType.error,
    );
  }
}