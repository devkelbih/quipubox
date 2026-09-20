import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quipubox/core/ui/navigation/app_status_tab_bar.dart';
import 'package:quipubox/features/lugares_operativos/presentation/viewmodels/lugares_operativos_viewmodel.dart';
import 'package:quipubox/features/puestos/presentation/screens/puestos_form_screen.dart';
import 'package:quipubox/features/puestos/presentation/viewmodels/puestos_viewmodel.dart';

import '../../../../core/ui/feedback/change_status_dialog.dart';
import '../../../../core/ui/sheets/app_bottom_sheet.dart';
import '../../../../core/ui/states/empty_state.dart';
import '../../../app_shell/presentation/widgets/app_scaffold.dart';
import '../../domain/entities/puesto.dart';
import '../widgets/puesto_card.dart';

class PuestoListScreen extends StatefulWidget {
  const PuestoListScreen({super.key});

  @override
  State<PuestoListScreen> createState() => _PuestoListScreenState();
}

class _PuestoListScreenState extends State<PuestoListScreen> {
  final TextEditingController _searchController = TextEditingController();

  StatusSummaryValue _statusFilter = StatusSummaryValue.all;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PuestoViewModel>().load();
      context.read<LugarOperativoViewModel>().load();
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();

    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PuestoViewModel>();

    final activeCount = vm.items.where((e) => e.estado).length;
    final inactiveCount = vm.items.length - activeCount;

    final search = _searchController.text.trim().toLowerCase();

    final filteredItems = vm.items.where((item) {
      final matchesStatus = switch (_statusFilter) {
        StatusSummaryValue.all => true,
        StatusSummaryValue.active => item.estado,
        StatusSummaryValue.inactive => !item.estado,
      };

      final matchesSearch =
          search.isEmpty || item.numeroPuesto.toLowerCase().contains(search);

      return matchesStatus && matchesSearch;
    }).toList();

    return AppScaffold(
      title: const Text('Puestos'),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Buscar por número de puesto',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: _searchController.clear,
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
            ),
          ),

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
                  message: 'Aún no tienes puestos registrados.',
                  actionLabel: 'Reintentar',
                  onAction: vm.load,
                );
              }

              if (filteredItems.isEmpty) {
                if (search.isNotEmpty) {
                  return EmptyState(
                    message: 'No se encontraron puestos con ese número.',
                    actionLabel: 'Limpiar búsqueda',
                    onAction: _searchController.clear,
                  );
                }

                return EmptyState(
                  message: _statusFilter == StatusSummaryValue.active
                      ? 'No tienes puestos activos.'
                      : 'No tienes puestos inactivos.',
                  actionLabel: 'Mostrar todos',
                  onAction: () {
                    setState(() => _statusFilter = StatusSummaryValue.all);
                  },
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await Future.wait([
                    vm.load(),
                    context.read<LugarOperativoViewModel>().load(),
                  ]);
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  children: [
                    ...filteredItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PuestoCard(
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

  Future<void> _openForm(BuildContext context, {Puesto? item}) async {
    final lugarVm = context.read<LugarOperativoViewModel>();

    if (lugarVm.items.isEmpty && !lugarVm.isLoading) {
      await lugarVm.load();
    }

    if (!context.mounted) return;

    await AppBottomSheet.show(
      context: context,
      title: item == null ? 'Nuevo puesto' : 'Editar puesto',
      initialChildSize: 0.45,
      maxChildSize: 0.5,
      builder: (context, controller) => SingleChildScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.all(20),
        child: PuestoFormScreen(item: item),
      ),
    );
  }

  Future<void> _confirmChangeStatus(BuildContext context, Puesto item) async {
    if (item.id == null) return;

    final vm = context.read<PuestoViewModel>();

    await ChangeStatusDialog.showAndAction(
      context: context,
      currentStatus: item.estado,
      article: 'El',
      entityName: 'Puesto',
      itemName: item.numeroPuesto,
      onConfirm: (newStatus) =>
          vm.changeStatus(id: item.id!, estado: newStatus),
      getErrorMessage: () => vm.errorMessage,
    );
  }
}
