import 'package:flutter/material.dart';
import 'package:quipubox/core/common/string_extensions.dart';
import 'package:provider/provider.dart';

import 'package:quipubox/core/ui/navigation/app_status_tab_bar.dart';
import 'package:quipubox/features/lugares_operativos/presentation/viewmodels/lugares_operativos_viewmodel.dart';
import 'package:quipubox/features/puestos/presentation/screens/puestos_form_screen.dart';
import 'package:quipubox/features/puestos/presentation/viewmodels/puestos_viewmodel.dart';
import 'package:quipubox/features/sedes/presentation/viewmodels/sedes_viewmodel.dart';

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

  int? _selectedSedeId;
  int? _selectedLugarOperativoId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PuestoViewModel>().load();
      context.read<SedeViewModel>().load();
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

    final search = _searchController.text.value.toLowerCase();

    final filteredItems = vm.items.where((item) {
      final matchesStatus = switch (_statusFilter) {
        StatusSummaryValue.all => true,
        StatusSummaryValue.active => item.estado,
        StatusSummaryValue.inactive => !item.estado,
      };

      final matchesSearch =
          search.isEmpty || item.numeroPuesto.toLowerCase().contains(search);

      final matchesSede =
          _selectedSedeId == null ||
          item.lugarOperativo?.idSede == _selectedSedeId;

      final matchesLugar =
          _selectedLugarOperativoId == null ||
          item.lugarOperativo?.id == _selectedLugarOperativoId;

      return matchesStatus && matchesSearch && matchesSede && matchesLugar;
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Buscar por número o código de puesto',
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
                const SizedBox(width: 8),
                _buildFilterButton(),
              ],
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
                final hasSearch = search.isNotEmpty;
                final hasFilters =
                    _selectedSedeId != null ||
                    _selectedLugarOperativoId != null;

                if (hasSearch || hasFilters) {
                  return EmptyState(
                    message:
                        'No se encontraron puestos con los filtros seleccionados.',
                    actionLabel: 'Limpiar filtros',
                    onAction: _clearFilters,
                  );
                }

                return EmptyState(
                  message: _statusFilter == StatusSummaryValue.active
                      ? 'No tienes puestos activos.'
                      : 'No tienes puestos inactivos.',
                  actionLabel: 'Mostrar todos',
                  onAction: () {
                    setState(() {
                      _statusFilter = StatusSummaryValue.all;
                    });
                  },
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await Future.wait([
                    vm.load(),
                    context.read<SedeViewModel>().load(),
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

  Widget _buildFilterButton() {
    final hasFilters =
        _selectedSedeId != null || _selectedLugarOperativoId != null;

    return IconButton(
      tooltip: 'Filtros',
      onPressed: () => _openFilters(context),
      icon: Badge(
        isLabelVisible: hasFilters,
        child: const Icon(Icons.tune_rounded),
      ),
    );
  }

  Future<void> _openFilters(BuildContext context) async {
    final sedes = context.read<SedeViewModel>().items;
    final lugares = context.read<LugarOperativoViewModel>().items;

    int? tempSedeId = _selectedSedeId;
    int? tempLugarOperativoId = _selectedLugarOperativoId;

    await AppBottomSheet.show(
      context: context,
      title: 'Filtros',
      minChildSize: 0.4,
      initialChildSize: 0.45,
      maxChildSize: 0.5,
      builder: (context, controller) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final lugaresFiltrados = tempSedeId == null
                ? lugares
                : lugares.where((lugar) => lugar.idSede == tempSedeId).toList();

            return SingleChildScrollView(
              controller: controller,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Sede',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<int>(
                    initialValue: tempSedeId ?? 0,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Todas las sedes',
                    ),
                    items: [
                      const DropdownMenuItem<int>(
                        value: 0,
                        child: Text('Todas las sedes'),
                      ),
                      ...sedes
                          .where((sede) => sede.id != null)
                          .map(
                            (sede) => DropdownMenuItem<int>(
                              value: sede.id!,
                              child: Text(
                                sede.nombre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                    ],
                    onChanged: (value) {
                      setSheetState(() {
                        tempSedeId = value == 0 ? null : value;

                        if (tempSedeId != null &&
                            !lugares.any(
                              (lugar) =>
                                  lugar.id == tempLugarOperativoId &&
                                  lugar.idSede == tempSedeId,
                            )) {
                          tempLugarOperativoId = null;
                        }
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Lugar operativo',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<int>(
                    initialValue: tempLugarOperativoId ?? 0,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Todos los lugares',
                    ),
                    items: [
                      const DropdownMenuItem<int>(
                        value: 0,
                        child: Text('Todos los lugares'),
                      ),
                      ...lugaresFiltrados
                          .where((lugar) => lugar.id != null)
                          .map(
                            (lugar) => DropdownMenuItem<int>(
                              value: lugar.id!,
                              child: Text(
                                lugar.nombre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                    ],
                    onChanged: (value) {
                      setSheetState(() {
                        tempLugarOperativoId = value == 0 ? null : value;
                      });
                    },
                  ),

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedSedeId = null;
                              _selectedLugarOperativoId = null;
                            });

                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.clear_rounded),
                          label: const Text('Limpiar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedSedeId = tempSedeId;
                              _selectedLugarOperativoId = tempLugarOperativoId;
                            });

                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.check_rounded),
                          label: const Text('Aplicar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _clearFilters() {
    _searchController.clear();

    setState(() {
      _selectedSedeId = null;
      _selectedLugarOperativoId = null;
      _statusFilter = StatusSummaryValue.all;
    });
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
      minChildSize: 0.4,
      initialChildSize: 0.5,
      maxChildSize: 0.55,
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
