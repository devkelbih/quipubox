import 'dart:async';
import '../../../sedes/presentation/viewmodels/sedes_viewmodel.dart';
import '../widgets/usuarios_list_filters.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:quipubox/core/navigation/app_routes.dart';
import 'package:quipubox/core/ui/feedback/app_toast.dart';
import 'package:quipubox/core/ui/navigation/app_status_tab_bar.dart';
import 'package:quipubox/core/ui/sheets/app_bottom_sheet.dart';
import 'package:quipubox/features/organizacion/roles/domain/entities/role.dart';
import 'package:quipubox/features/organizacion/roles/presentation/viewmodels/roles_viewmodel.dart';
import 'package:quipubox/features/organizacion/usuarios/presentation/widgets/usuario_roles_sheet.dart';

import '../../../../../core/ui/feedback/change_status_dialog.dart';
import '../../../../../core/ui/states/empty_state.dart';
import '../../../../app_shell/presentation/widgets/app_scaffold.dart';
import '../../domain/entities/usuario.dart';
import '../viewmodels/usuarios_viewmodel.dart';
import '../widgets/usuario_card.dart';

class UsuarioListScreen extends StatefulWidget {
  const UsuarioListScreen({super.key});

  @override
  State<UsuarioListScreen> createState() => _UsuarioListScreenState();
}

class _UsuarioListScreenState extends State<UsuarioListScreen> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _lastSearchText = '';
  String _appliedSearch = '';
  int? _selectedSedeId;
  StatusSummaryValue _statusFilter = StatusSummaryValue.all;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final sedesVm = context.read<SedeViewModel>();
      if (sedesVm.items.isEmpty) sedesVm.load();
      context.read<UsuarioViewModel>().load();
      context.read<RolesViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UsuarioViewModel>();

    final activeCount = vm.items.where((e) => e.estado).length;
    final inactiveCount = vm.items.length - activeCount;

    final statusItems = switch (_statusFilter) {
      StatusSummaryValue.all => vm.items,
      StatusSummaryValue.active => vm.items.where((e) => e.estado).toList(),
      StatusSummaryValue.inactive => vm.items.where((e) => !e.estado).toList(),
    };

    final filteredItems = statusItems
        .where(
          (item) =>
              (_selectedSedeId == null || item.idSede == _selectedSedeId) &&
              (_appliedSearch.isEmpty ||
                  [
                    item.nombreCompleto,
                    item.email,
                    item.telefono ?? '',
                  ].any((text) => text.toLowerCase().contains(_appliedSearch))),
        )
        .toList();

    final isSavingUser = vm.isSaving && vm.processingRoleId == null;

    return AppScaffold(
      title: const Text('Usuarios'),
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _applySearch(),
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre, correo o teléfono',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Limpiar búsqueda',
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: _searchController.clear,
                            ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Filtros',
                  onPressed: _openFilters,
                  icon: Badge(
                    isLabelVisible: _selectedSedeId != null,
                    child: const Icon(Icons.tune_rounded),
                  ),
                ),
              ],
            ),
          ),
          if (isSavingUser || vm.isDeleting || vm.isChangingStatus)
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
                  message: 'Aún no tienes usuarios registrados.',
                  actionLabel: 'Reintentar',
                  onAction: vm.load,
                );
              }

              if (filteredItems.isEmpty) {
                return EmptyState(
                  message: _appliedSearch.isNotEmpty || _selectedSedeId != null
                      ? 'No se encontraron usuarios con los filtros seleccionados.'
                      : _statusFilter == StatusSummaryValue.active
                      ? 'No tienes usuarios activos.'
                      : 'No tienes usuarios inactivos.',
                  actionLabel: 'Mostrar todos',
                  onAction: () {
                    _searchController.clear();
                    _applySearch();
                    setState(() {
                      _statusFilter = StatusSummaryValue.all;
                      _selectedSedeId = null;
                    });
                  },
                );
              }

              return RefreshIndicator(
                onRefresh: vm.load,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const SizedBox(height: 14),
                    ...filteredItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: UsuarioCard(
                          item: item,
                          onEdit: () => _openForm(context, item: item),
                          onChangeStatus: () =>
                              _confirmChangeStatus(context, item),
                          onManageRoles: () => _showRoles(context, item),
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

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_lastSearchText == _searchController.text) return;
    _lastSearchText = _searchController.text;
    setState(() {});
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), _applySearch);
  }

  void _applySearch() {
    _searchDebounce?.cancel();
    if (mounted) {
      setState(
        () => _appliedSearch = _searchController.text.trim().toLowerCase(),
      );
    }
  }

  Future<void> _openFilters() async {
    final result = await AppBottomSheet.show<int>(
      context: context,
      title: 'Filtros',
      minChildSize: .30,
      initialChildSize: .35,
      maxChildSize: .40,
      builder: (context, controller) => UsuarioListFilters(
        controller: controller,
        sedes: context.read<SedeViewModel>().items,
        initialSedeId: _selectedSedeId,
      ),
    );
    if (result == null || !mounted) return;
    setState(() => _selectedSedeId = result == 0 ? null : result);
  }

  Future<void> _openForm(BuildContext context, {Usuario? item}) async {
    context.push(AppRoutes.usuariosForm, extra: item);
  }

  Future<void> _confirmChangeStatus(BuildContext context, Usuario item) async {
    if (item.id == null) return;

    final vm = context.read<UsuarioViewModel>();

    await ChangeStatusDialog.showAndAction(
      context: context,
      currentStatus: item.estado,
      article: 'El',
      entityName: 'Usuario',
      itemName: item.nombreCompleto,
      onConfirm: (newStatus) =>
          vm.changeStatus(id: item.id!, estado: newStatus),
      getErrorMessage: () => vm.errorMessage,
    );
  }

  Future<void> _showRoles(BuildContext context, Usuario item) async {
    await AppBottomSheet.show(
      context: context,
      title: 'Gestionar roles',
      minChildSize: 0.4,
      initialChildSize: 0.55,
      maxChildSize: 0.70,
      builder: (sheetContext, controller) {
        return Consumer2<UsuarioViewModel, RolesViewModel>(
          builder: (context, usuarioVm, rolesVm, _) {
            if (rolesVm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (rolesVm.errorMessage != null && rolesVm.roles.isEmpty) {
              return EmptyState(
                message: rolesVm.errorMessage!,
                actionLabel: 'Reintentar',
                onAction: rolesVm.load,
              );
            }

            final currentUsuario = usuarioVm.items.firstWhere(
              (e) => e.id == item.id,
              orElse: () => item,
            );

            return UsuarioRolesSheet(
              usuario: currentUsuario,
              roles: rolesVm.roles,
              controller: controller,
              isSaving: usuarioVm.isSaving,
              processingRoleId: usuarioVm.processingRoleId,
              onAddRole: (role) =>
                  _addRole(context, usuario: currentUsuario, role: role),
              onRemoveRole: (role) =>
                  _removeRole(context, usuario: currentUsuario, role: role),
            );
          },
        );
      },
    );
  }

  Future<void> _addRole(
    BuildContext context, {
    required Usuario usuario,
    required Role role,
  }) async {
    if (usuario.id == null) return;

    final vm = context.read<UsuarioViewModel>();

    final ok = await vm.addRole(usuarioId: usuario.id!, role: role);

    if (!mounted) return;

    AppToast.show(
      ok
          ? 'Rol agregado correctamente.'
          : vm.errorMessage ?? 'No se pudo agregar el rol.',
      type: ok ? ToastType.success : ToastType.error,
    );
  }

  Future<void> _removeRole(
    BuildContext context, {
    required Usuario usuario,
    required Role role,
  }) async {
    if (usuario.id == null) return;

    final vm = context.read<UsuarioViewModel>();

    final ok = await vm.removeRole(usuarioId: usuario.id!, roleId: role.id);

    if (!mounted) return;

    AppToast.show(
      ok
          ? 'Rol quitado correctamente.'
          : vm.errorMessage ?? 'No se pudo quitar el rol.',
      type: ok ? ToastType.success : ToastType.error,
    );
  }
}
