import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/ui/feedback/change_status_dialog.dart';
import 'package:quipubox/core/ui/sheets/app_form_sheet.dart';
import 'package:quipubox/features/frutas/presentation/widgets/fruta_card.dart';

import '../../../../core/ui/feedback/app_toast.dart';
import '../../../../core/ui/filters/status_summary_filter.dart';
import '../../../../core/ui/layout/app_scaffold.dart';
import '../../../../core/ui/states/empty_state.dart';
import '../../domain/entities/fruta.dart';
import '../viewmodels/frutas_viewmodel.dart';
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
      title: 'Frutas',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva fruta'),
      ),
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
                  return const EmptyState('Aún no tienes frutas registradas.');
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
                          child: FrutaCard(
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

  Future<void> _openForm(BuildContext context, {Fruta? item}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: context.read<FrutaViewModel>(),
          child: AppFormSheet(
            title: item == null ? 'Nueva fruta' : 'Editar fruta',
            child: FrutaFormScreen(item: item),
          ),
        );
      },
    );
  }

  Future<void> _confirmChangeStatus(BuildContext context, Fruta item) async {
    final newStatus = !item.estado;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return ChangeStatusDialog(
          newStatus: newStatus,
          title: newStatus ? 'Activar fruta' : 'Desactivar fruta',
          message: newStatus
              ? 'La fruta "${item.nombre}" volverá a estar disponible para nuevas operaciones.'
              : 'La fruta "${item.nombre}" dejará de estar disponible para nuevas operaciones.',
          confirmText: newStatus ? 'Activar' : 'Desactivar',
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final id = item.id;

    if (id == null) {
      AppToast.show('No se encontró el ID de la fruta.', type: ToastType.error);
      return;
    }

    final viewModel = context.read<FrutaViewModel>();
    final ok = await viewModel.changeStatus(id: id, estado: newStatus);

    if (!context.mounted) return;

    AppToast.show(
      ok
          ? newStatus
                ? 'Fruta activada correctamente.'
                : 'Fruta desactivada correctamente.'
          : viewModel.errorMessage ??
                (newStatus
                    ? 'No se pudo activar la fruta.'
                    : 'No se pudo desactivar la fruta.'),
      type: ok ? ToastType.success : ToastType.error,
    );
  }
}
