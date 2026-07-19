import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/features/usuarios/presentation/screens/usuarios_form_screen.dart';

import '../../../../core/ui/feedback/app_toast.dart';
import '../../../../core/ui/feedback/change_status_dialog.dart';
import '../../../../core/ui/filters/status_summary_filter.dart';
import '../../../../core/ui/sheets/app_form_sheet.dart';
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
      title: 'Usuarios',
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
                  return const EmptyState('Aún no tienes usuarios registrados.');
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
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {Usuario? item}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: context.read<UsuarioViewModel>(),
          child: AppFormSheet(
            title: item == null ? 'Nuevo usuario' : 'Editar usuario',
            child: UsuariosFormScreen(item: item),
          ),
        );
      },
    );
  }

  Future<void> _confirmChangeStatus(BuildContext context, Usuario item) async {
    final newStatus = !item.estado;
    final name = item.nombreCompleto.isNotEmpty
        ? item.nombreCompleto
        : 'Usuario #${item.id}';

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return ChangeStatusDialog(
          newStatus: newStatus,
          title: newStatus ? 'Activar usuario' : 'Desactivar usuario',
          message: newStatus
              ? 'El usuario "$name" volverá a tener acceso al sistema.'
              : 'El usuario "$name" dejará de tener acceso al sistema.',
          confirmText: newStatus ? 'Activar' : 'Desactivar',
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final viewModel = context.read<UsuarioViewModel>();

    final ok = await viewModel.changeStatus(
      id: item.id,
      estado: newStatus,
    );

    if (!context.mounted) return;

    AppToast.show(
      ok
          ? newStatus
              ? 'Usuario activado correctamente.'
              : 'Usuario desactivado correctamente.'
          : viewModel.errorMessage ??
              (newStatus
                  ? 'No se pudo activar el usuario.'
                  : 'No se pudo desactivar el usuario.'),
      type: ok ? ToastType.success : ToastType.error,
    );
  }
}