import 'dart:async';
import '../widgets/clientes_list_filters.dart';
import '../../../../../core/ui/sheets/app_bottom_sheet.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:quipubox/core/navigation/app_routes.dart';
import 'package:quipubox/core/ui/feedback/change_status_dialog.dart';
import 'package:quipubox/core/ui/navigation/app_status_tab_bar.dart';
import 'package:quipubox/core/ui/states/empty_state.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente.dart';
import 'package:quipubox/features/organizacion/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:quipubox/features/organizacion/clientes/presentation/widgets/cliente_card.dart';
import '../widgets/clientes_pagination_bar.dart';

import '../../../../app_shell/presentation/widgets/app_scaffold.dart';

class ClienteListScreen extends StatefulWidget {
  const ClienteListScreen({super.key});

  @override
  State<ClienteListScreen> createState() => _ClienteListScreenState();
}

class _ClienteListScreenState extends State<ClienteListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _lastSearchText = '';
  String? _selectedRelacion;
  StatusSummaryValue _statusFilter = StatusSummaryValue.all;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _applyFilters();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_lastSearchText == _searchController.text) return;
    _lastSearchText = _searchController.text;
    setState(() {});
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) _applyFilters();
    });
  }

  void _applyFilters() {
    _searchDebounce?.cancel();
    context.read<ClienteViewModel>().setFilters(
      buscar: _searchController.text,
      tipoRelacion: _selectedRelacion,
      estado: switch (_statusFilter) {
        StatusSummaryValue.all => null,
        StatusSummaryValue.active => true,
        StatusSummaryValue.inactive => false,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClienteViewModel>();

    final search = _searchController.text.trim();

    return AppScaffold(
      title: const Text('Clientes'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add_rounded),
          onPressed: vm.isBusy ? null : () => _openForm(context),
        ),
      ],
      appBarBottom: AppStatusTabBar(
        total: vm.totalCount,
        active: vm.activeCount,
        inactive: vm.inactiveCount,
        selected: _statusFilter,
        onChanged: (value) {
          setState(() => _statusFilter = value);
          _applyFilters();
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _applyFilters(),
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre, apodo o teléfono',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: search.isNotEmpty
                          ? IconButton(
                              tooltip: 'Limpiar búsqueda',
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: _searchController.clear,
                            )
                          : null,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Filtros',
                  onPressed: _openFilters,
                  icon: Badge(
                    isLabelVisible: _selectedRelacion != null,
                    child: const Icon(Icons.tune_rounded),
                  ),
                ),
              ],
            ),
          ),
          if (vm.isSaving || vm.isChangingStatus)
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
                  message:
                      search.isNotEmpty ||
                          _statusFilter != StatusSummaryValue.all ||
                          _selectedRelacion != null
                      ? 'No se encontraron clientes con la búsqueda y el estado seleccionados.'
                      : 'Aún no tienes clientes registrados.',
                  actionLabel: 'Reintentar',
                  onAction: vm.load,
                );
              }

              return RefreshIndicator(
                onRefresh: vm.load,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  children: [
                    ...vm.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ClienteCard(
                          item: item,
                          onEdit: () {
                            if (!vm.isBusy) _openForm(context, item: item);
                          },
                          onChangeStatus: () => vm.isBusy
                              ? null
                              : _confirmChangeStatus(context, item),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }(),
          ),
          if (vm.errorMessage != null && vm.items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton.icon(
                onPressed: vm.isBusy ? null : vm.load,
                icon: const Icon(Icons.refresh),
                label: Text(vm.errorMessage!),
              ),
            ),
          ClientesPaginationBar(
            page: vm.currentPage,
            totalPages: vm.totalPages,
            total: vm.total,
            busy: vm.isBusy,
            onPage: (page) => vm.load(page: page),
          ),
        ],
      ),
    );
  }

  Future<void> _openFilters() async {
    // TODO: Habilitar sede cuando GET /clientes acepte id_sede antes de paginar.
    final result = await AppBottomSheet.show<({int? sedeId, String? relacion})>(
      context: context,
      title: 'Filtros',
      minChildSize: .40,
      initialChildSize: .50,
      maxChildSize: .60,
      builder: (context, controller) => ClienteListFilters(
        controller: controller,
        initialRelacion: _selectedRelacion,
      ),
    );
    if (result == null || !mounted || result.relacion == _selectedRelacion) {
      return;
    }
    setState(() => _selectedRelacion = result.relacion);
    _applyFilters();
  }

  Future<void> _openForm(BuildContext context, {Cliente? item}) async {
    context.push(AppRoutes.clientesForm, extra: item);
  }

  Future<void> _confirmChangeStatus(BuildContext context, Cliente item) async {
    if (item.id == null) return;

    final vm = context.read<ClienteViewModel>();

    await ChangeStatusDialog.showAndAction(
      context: context,
      currentStatus: item.estado,
      article: 'El',
      entityName: 'Cliente',
      itemName: item.nombreCompleto,
      onConfirm: (newStatus) =>
          vm.changeStatus(id: item.id!, estado: newStatus),
      getErrorMessage: () => vm.errorMessage,
    );
  }
}
