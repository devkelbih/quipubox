import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/navigation/app_routes.dart';
import '../../../../../core/ui/states/empty_state.dart';
import '../../../../../core/ui/sheets/app_bottom_sheet.dart';
import '../../../../app_shell/presentation/widgets/app_scaffold.dart';
import '../viewmodels/reparto_list_viewmodel.dart';
import '../widgets/reparto_operacion_card.dart';

class RepartoListScreen extends StatefulWidget {
  const RepartoListScreen({super.key});
  @override
  State<RepartoListScreen> createState() => _RepartoListScreenState();
}

class _RepartoListScreenState extends State<RepartoListScreen> {
  final _search = TextEditingController();
  Timer? _debounce;
  String _query = '';
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

  Future<void> _filters() async {
    final vm = context.read<RepartoListViewModel>();
    String? estado = vm.estado;
    DateTime? fecha = vm.fecha;
    final result =
        await AppBottomSheet.show<({String? estado, DateTime? fecha})>(
          context: context,
          title: 'Filtrar operaciones',
          minChildSize: .35,
          initialChildSize: .45,
          maxChildSize: .6,
          builder: (context, controller) => StatefulBuilder(
            builder: (context, sheetState) => ListView(
              controller: controller,
              padding: const EdgeInsets.all(20),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: estado ?? 'todos',
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Estado'),
                  items: [
                    const DropdownMenuItem(
                      value: 'todos',
                      child: Text('Todos los estados'),
                    ),
                    for (final value in [
                      'pendiente',
                      'en_curso',
                      'en_transito',
                      'repartiendo',
                      'completado',
                    ])
                      DropdownMenuItem(
                        value: value,
                        child: Text(repartoOperacionStatus(value).label),
                      ),
                  ],
                  onChanged: (v) =>
                      sheetState(() => estado = v == 'todos' ? null : v),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () async {
                    final today = DateTime.now();
                    final date = await showDatePicker(
                      context: context,
                      initialDate: fecha ?? today,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(today.year + 1, 12, 31),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      locale: const Locale('es', 'PE'),
                      cancelText: 'Cancelar',
                      confirmText: 'Confirmar',
                    );
                    if (date != null && context.mounted) {
                      sheetState(() => fecha = date);
                    }
                  },
                  icon: const Icon(Icons.calendar_month_rounded),
                  label: Text(
                    fecha == null ? 'Todas las fechas' : repartoFecha(fecha!),
                  ),
                ),
                if (fecha != null)
                  TextButton(
                    onPressed: () => sheetState(() => fecha = null),
                    child: const Text('Quitar fecha'),
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            Navigator.pop(context, (estado: null, fecha: null)),
                        child: const Text('Limpiar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context, (
                          estado: estado,
                          fecha: fecha,
                        )),
                        child: const Text('Aplicar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
    if (result != null && mounted) {
      await vm.setFilters(estado: result.estado, fecha: result.fecha);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RepartoListViewModel>();
    final items = vm.operaciones
        .where(
          (o) =>
              '${o.id} ${o.camion?.placa ?? ''} ${o.sedeOrigen?.nombre ?? ''} ${o.sedeDestino?.nombre ?? ''}'
                  .toLowerCase()
                  .contains(_query),
        )
        .toList();
    return AppScaffold(
      title: const Text('Repartos'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _search,
                    onChanged: (_) {
                      _debounce?.cancel();
                      _debounce = Timer(
                        const Duration(milliseconds: 350),
                        _applySearch,
                      );
                    },
                    onSubmitted: (_) => _applySearch(),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Buscar operación, placa o ruta',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                        tooltip: 'Limpiar búsqueda',
                        onPressed: () {
                          _search.clear();
                          _applySearch();
                        },
                        icon: const Icon(Icons.clear_rounded),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Filtrar operaciones',
                  onPressed: vm.isLoading ? null : _filters,
                  icon: Badge(
                    isLabelVisible: vm.estado != null || vm.fecha != null,
                    child: const Icon(Icons.tune_rounded),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.errorMessage != null
                ? EmptyState(
                    message: vm.errorMessage!,
                    actionLabel: 'Reintentar',
                    onAction: vm.load,
                  )
                : RefreshIndicator(
                    onRefresh: vm.load,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: items.isEmpty ? 1 : items.length,
                      itemBuilder: (context, index) {
                        if (items.isEmpty) {
                          return const EmptyState(
                            message:
                                'No hay operaciones con los filtros seleccionados.',
                          );
                        }
                        final o = items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RepartoOperacionCard(
                            item: o,
                            onOpen: () => context.push(
                              AppRoutes.repartoOperacionPath(o.id!),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
