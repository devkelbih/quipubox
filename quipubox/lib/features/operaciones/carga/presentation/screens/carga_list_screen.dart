import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/ui/navigation/app_filter_tab_bar.dart';
import 'package:quipubox/features/operaciones/carga/domain/enums/estado_operacion_carga.dart';

import '../../../../../core/navigation/app_routes.dart';
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
  /// Tabs de dominio: SIN 'todos'. AppFilterTabBar lo antepone.
  static final _domainStatuses = EstadoOperacionCarga.values
      .map((e) => (e.value, e.label))
      .toList(growable: false);

  String _statusFilter = 'todos'; // 'todos' siempre existe y es el primero.

  bool _matchesStatus(OperacionCarga item, String status) =>
      status == 'todos' || item.estado == status;

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
        .where((item) => _matchesStatus(item, _statusFilter))
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
      appBarBottom: AppFilterTabBar(
        tabs: _domainStatuses
            .map(
              (s) => AppFilterTab(
                value: s.$1,
                label: s.$2,
                count: vm.items.where((i) => _matchesStatus(i, s.$1)).length,
              ),
            )
            .toList(),
        totalOverride: vm.items.length, // total real (evita sobreconteo)
        selected: _statusFilter,
        onChanged: (value) => setState(() => _statusFilter = value), // solo UI
      ),
      body: Column(
        children: [
          if (vm.isSaving || vm.isDeleting || vm.isChangingStatus)
            const LinearProgressIndicator(),
          Expanded(
            child: () {
              // 1. Cargando inicial (sin datos aún).
              if (vm.isLoading && vm.items.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // 2. Error inicial (sin datos).
              if (vm.errorMessage != null && vm.items.isEmpty) {
                return EmptyState(
                  message: vm.errorMessage!,
                  actionLabel: 'Reintentar',
                  onAction: vm.load,
                );
              }

              // 3. Lista completa vacía (no hay operaciones en absoluto).
              if (vm.items.isEmpty) {
                return EmptyState(
                  message: 'Aún no tienes operaciones de carga.',
                  actionLabel: 'Reintentar',
                  onAction: vm.load,
                );
              }

              // 4. Tab activo vacío (hay datos, pero no en este filtro).
              //    El usuario decide volver a 'todos' con el botón.
              //    No se recarga: solo se cambia el filtro.
              if (filteredItems.isEmpty) {
                final label = _domainStatuses
                    .firstWhere((s) => s.$1 == _statusFilter)
                    .$2
                    .toLowerCase();
                return EmptyState(
                  message: 'No hay operaciones con estado $label.',
                  actionLabel: 'Ver todos',
                  onAction: () => setState(() => _statusFilter = 'todos'),
                );
              }

              // 5. Lista con items.
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
                          onAssignCarga: () => _openAsignarCarga(context, item),
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
      minChildSize: 0.75,
      initialChildSize: 0.8,
      maxChildSize: 0.85,
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
    context.push(AppRoutes.operacionCargaDetailPath(id), extra: item);
  }

  // TODO: Implementar la pantalla/formulario para asignar detalle a la carga
  void _openAsignarCarga(BuildContext context, OperacionCarga item) {
    final id = item.id;
    if (id == null) return;

    // Feedback temporal para saber que el botón funciona
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Próximamente: Asignar carga a la operación #$id'),
      ),
    );

    // Aquí irá la navegación futura, por ejemplo:
    // context.push(AppRoutes.operacionCargaAsignarPath(id));
    // o abrir un AppBottomSheet con el formulario de detalle de carga.
  }
}
