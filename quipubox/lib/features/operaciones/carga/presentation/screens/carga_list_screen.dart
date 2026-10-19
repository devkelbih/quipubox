import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/navigation/app_routes.dart';
import '../../../../../core/ui/feedback/change_status_dialog.dart';
import '../../../../../core/ui/navigation/app_status_tab_bar.dart';
import '../../../../../core/ui/sheets/app_bottom_sheet.dart';
import '../../../../../core/ui/states/empty_state.dart';
import '../../../../app_shell/presentation/widgets/app_scaffold.dart';
import '../../domain/entities/operacion_carga.dart';
import '../viewmodels/carga_viewmodel.dart';
import '../widgets/carga_card.dart';
import 'carga_form_screen.dart';

class CargaListScreen extends StatefulWidget {
  const CargaListScreen({super.key});

  @override
  State<CargaListScreen> createState() => _CargaListScreenState();
}

class _CargaListScreenState extends State<CargaListScreen> {
  static const _statuses = [
    ('pendiente', 'Pendiente'),
    ('en_curso', 'En curso'),
    ('repartiendo', 'Repartiendo'),
    ('cancelada', 'Cancelada'),
  ];

  String _statusFilter = 'pendiente';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<CargaViewModel>().load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CargaViewModel>();
    final filteredItems = vm.items
        .where((item) => item.estado == _statusFilter)
        .toList();

    return AppScaffold(
      title: const Text('Operaciones de carga'),
      actions: [
        IconButton(
          tooltip: 'Nueva operación',
          icon: const Icon(Icons.add_rounded),
          onPressed: vm.isSaving ? null : () => _openForm(context),
        ),
      ],
      appBarBottom: AppStatusTabBar.forStatuses(
        tabs: _statuses
            .map(
              (status) => StatusFilterTab(
                value: status.$1,
                label: status.$2,
                count: vm.items
                    .where((item) => item.estado == status.$1)
                    .length,
              ),
            )
            .toList(),
        selected: _statusFilter,
        onChanged: (value) => setState(() => _statusFilter = value),
      ),
      body: Column(
        children: [
          if (vm.isSaving || vm.isDeleting || vm.isChangingStatus)
            const LinearProgressIndicator(),
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
                  message: 'Aún no tienes operaciones de carga.',
                  actionLabel: 'Reintentar',
                  onAction: vm.load,
                );
              }

              if (filteredItems.isEmpty) {
                final label = _statuses
                    .firstWhere((status) => status.$1 == _statusFilter)
                    .$2
                    .toLowerCase();
                return EmptyState(
                  message: 'No hay operaciones con estado $label.',
                  actionLabel: 'Actualizar',
                  onAction: vm.load,
                );
              }

              return RefreshIndicator(
                onRefresh: vm.load,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...filteredItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CargaCard(
                          item: item,
                          onOpen: () => _openDetails(context, item),
                          onEdit: () => _openForm(context, item: item),
                          onCancel: () => _confirmCancel(context, item),
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

  Future<void> _openForm(BuildContext context, {OperacionCarga? item}) async {
    await AppBottomSheet.show<void>(
      context: context,
      title: item == null ? 'Nueva operación' : 'Editar operación',
      minChildSize: 0.65,
      initialChildSize: 0.88,
      maxChildSize: 0.96,
      builder: (context, controller) => SingleChildScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.all(20),
        child: CargaFormScreen(item: item),
      ),
    );
  }

  void _openDetails(BuildContext context, OperacionCarga item) {
    final id = item.id;
    if (id == null) return;
    context.push(AppRoutes.operacionCargaDetailPath(id));
  }

  Future<void> _confirmCancel(BuildContext context, OperacionCarga item) async {
    final id = item.id;
    if (id == null) return;
    final vm = context.read<CargaViewModel>();

    await ChangeStatusDialog.showAndAction(
      context: context,
      currentStatus: true,
      article: 'La',
      entityName: 'operación de carga',
      itemName: '#$id',
      actionLabel: 'Cancelar',
      successMessageOverride: 'Operación de carga cancelada correctamente.',
      fallbackErrorOverride: 'No se pudo cancelar la operación de carga.',
      onConfirm: (newStatus) async => newStatus ? false : vm.cancelar(id),
      getErrorMessage: () => vm.errorMessage,
    );
  }
}
