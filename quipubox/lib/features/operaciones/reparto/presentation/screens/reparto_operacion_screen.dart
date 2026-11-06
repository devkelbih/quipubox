import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/navigation/app_routes.dart';
import '../../../../../core/ui/states/empty_state.dart';
import '../../../../../core/ui/sheets/app_bottom_sheet.dart';
import '../../../carga/domain/entities/detalle_carga.dart';
import '../../domain/entities/distribucion_operacion.dart';
import '../viewmodels/reparto_operacion_viewmodel.dart';
import '../widgets/distribucion_resumen_card.dart';
import '../widgets/reparto_carga_card.dart';
import '../widgets/reparto_card.dart';

class RepartoOperacionScreen extends StatefulWidget {
  final int operacionId;
  const RepartoOperacionScreen({super.key, required this.operacionId});
  @override
  State<RepartoOperacionScreen> createState() => _RepartoOperacionScreenState();
}

class _RepartoOperacionScreenState extends State<RepartoOperacionScreen> {
  final _search = TextEditingController();
  Timer? _debounce;
  String _query = '';
  int _tab = 0;
  int _filter = 0;
  static const _filters = [
    'Todas las cargas',
    'Sin destinatario',
    'Asignación parcial',
    'Calidades incompletas',
  ];
  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _applySearch() {
    _debounce?.cancel();
    setState(() => _query = _search.text.trim().toLowerCase());
  }

  Future<void> _open(int id) async {
    await context.push(AppRoutes.repartoDetailPath(widget.operacionId, id));
    if (mounted) {
      await context.read<RepartoOperacionViewModel>().load(widget.operacionId);
    }
  }

  Future<void> _openFilters() async {
    var filter = _filter;
    final result = await AppBottomSheet.show<int>(
      context: context,
      title: 'Filtrar cargas',
      minChildSize: .25,
      initialChildSize: .35,
      maxChildSize: .45,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<int>(
            initialValue: filter,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Situación de la carga',
            ),
            items: _filters.indexed
                .map(
                  (entry) =>
                      DropdownMenuItem(value: entry.$1, child: Text(entry.$2)),
                )
                .toList(),
            onChanged: (v) => filter = v ?? 0,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, 0),
                  child: const Text('Limpiar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, filter),
                  child: const Text('Aplicar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    if (result != null && mounted) setState(() => _filter = result);
  }

  bool _matches(DetalleCarga d, DistribucionOperacion data) =>
      switch (_filter) {
        1 => data.asignadasCarga(d.id) == 0,
        2 =>
          data.asignadasCarga(d.id) > 0 &&
              data.asignadasCarga(d.id) < d.cantidadJabas,
        3 =>
          d.cantidadClasificada == null ||
              d.cantidadClasificada != d.cantidadJabas,
        _ => true,
      };
  String _searchCarga(DetalleCarga d) =>
      '${d.id} ${d.fruta?.nombre ?? ''} ${d.variedad?.nombre ?? ''} ${d.clienteEmisor?.nombreCompleto ?? ''}'
          .toLowerCase();
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RepartoOperacionViewModel>();
    final data = vm.data;
    return Scaffold(
      appBar: AppBar(
        title: Text('Distribución · operación #${widget.operacionId}'),
      ),
      body: SafeArea(
        top: false,
        child: data == null
            ? vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : EmptyState(
                      message:
                          vm.errorMessage ?? 'No se pudo cargar la operación.',
                      actionLabel: 'Reintentar',
                      onAction: () => vm.load(widget.operacionId),
                    )
            : Builder(
                builder: (context) {
                  final cargas = data.cargas
                      .where(
                        (d) =>
                            _matches(d, data) &&
                            _searchCarga(d).contains(_query),
                      )
                      .toList();
                  final asignaciones = data.asignaciones.where((a) {
                    final carga = data.cargas
                        .where((d) => d.id == a.detalleId)
                        .firstOrNull;
                    return carga != null &&
                        _matches(carga, data) &&
                        '${_searchCarga(carga)} ${a.receptor?.nombreCompleto ?? ''} ${a.puesto?.numeroPuesto ?? ''}'
                            .toLowerCase()
                            .contains(_query);
                  }).toList();
                  final count = _tab == 0 ? cargas.length : asignaciones.length;
                  return Column(
                    children: [
                      if (vm.isLoading) const LinearProgressIndicator(),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => vm.load(widget.operacionId),
                          child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  0,
                                ),
                                sliver: SliverToBoxAdapter(
                                  child: Column(
                                    children: [
                                      if (vm.errorMessage != null)
                                        EmptyState(
                                          message: vm.errorMessage!,
                                          actionLabel: 'Actualizar',
                                          onAction: () =>
                                              vm.load(widget.operacionId),
                                        ),
                                      DistribucionResumenCard(data: data),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _search,
                                              textInputAction:
                                                  TextInputAction.search,
                                              onSubmitted: (_) =>
                                                  _applySearch(),
                                              onChanged: (_) {
                                                _debounce?.cancel();
                                                _debounce = Timer(
                                                  const Duration(
                                                    milliseconds: 350,
                                                  ),
                                                  _applySearch,
                                                );
                                              },
                                              decoration: InputDecoration(
                                                hintText: _tab == 0
                                                    ? 'Buscar emisor, fruta o variedad'
                                                    : 'Buscar receptor, puesto o carga',
                                                prefixIcon: const Icon(
                                                  Icons.search_rounded,
                                                ),
                                                suffixIcon: IconButton(
                                                  tooltip: 'Limpiar búsqueda',
                                                  onPressed: () {
                                                    _search.clear();
                                                    _applySearch();
                                                  },
                                                  icon: const Icon(
                                                    Icons.clear_rounded,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            tooltip: 'Filtrar cargas',
                                            onPressed: _openFilters,
                                            icon: Badge(
                                              isLabelVisible: _filter != 0,
                                              child: const Icon(
                                                Icons.tune_rounded,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: SegmentedButton<int>(
                                          segments: [
                                            ButtonSegment(
                                              value: 0,
                                              label: Text(
                                                'Cargas (${data.cargas.length})',
                                              ),
                                            ),
                                            ButtonSegment(
                                              value: 1,
                                              label: Text(
                                                'Asignaciones (${data.asignaciones.length})',
                                              ),
                                            ),
                                          ],
                                          selected: {_tab},
                                          onSelectionChanged: (v) =>
                                              setState(() => _tab = v.single),
                                        ),
                                      ),
                                      if (_filter != 0)
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: InputChip(
                                            label: Text(_filters[_filter]),
                                            onDeleted: () =>
                                                setState(() => _filter = 0),
                                          ),
                                        ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ),
                              if (count == 0)
                                const SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.all(24),
                                    child: Text(
                                      'No hay registros con los filtros seleccionados.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                sliver: SliverList.builder(
                                  itemCount: count,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _tab == 0
                                        ? RepartoCargaCard(
                                            carga: cargas[index],
                                            asignaciones: data.asignaciones
                                                .where(
                                                  (a) =>
                                                      a.detalleId ==
                                                      cargas[index].id,
                                                )
                                                .toList(),
                                            onOpen: () =>
                                                _open(cargas[index].id!),
                                          )
                                        : RepartoCard(
                                            item: asignaciones[index],
                                            onOpen: () => _open(
                                              asignaciones[index].detalleId,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
