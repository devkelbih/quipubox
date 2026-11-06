import '../../domain/entities/detalle_carga_calidad.dart';
import 'package:flutter/material.dart';
import '../../../../../core/ui/states/empty_state.dart';
import '../../domain/entities/detalle_carga.dart';
import '../../domain/entities/operacion_carga.dart';
import 'detalle_carga_row.dart';
import 'operacion_carga_summary.dart';

class CargaDetailsList extends StatefulWidget {
  final OperacionCarga operation;
  final List<DetalleCarga> detalles;
  final bool isBusy;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function() onRefresh;
  final VoidCallback onAddDetalle;
  final VoidCallback onFinalizar;
  final ValueChanged<DetalleCarga> onAddCalidad;
  final ValueChanged<DetalleCarga> onEditDetalle;
  final void Function(DetalleCarga, DetalleCargaCalidad) onEditCalidad;
  final ValueChanged<DetalleCarga> onDeleteDetalle;

  const CargaDetailsList({
    super.key,
    required this.operation,
    required this.detalles,
    required this.isBusy,
    required this.isLoading,
    this.errorMessage,
    required this.onRefresh,
    required this.onAddDetalle,
    required this.onFinalizar,
    required this.onAddCalidad,
    required this.onEditDetalle,
    required this.onEditCalidad,
    required this.onDeleteDetalle,
  });

  @override
  State<CargaDetailsList> createState() => _CargaDetailsListState();
}

class _CargaDetailsListState extends State<CargaDetailsList> {
  // TODO: Persistir mediante la API cuando exista soporte para ordenar detalles.
  List<int> _order = [];
  List<int>? _draft;

  bool get _canModify => const [
    'pendiente',
    'en_curso',
    'en_transito',
  ].contains(widget.operation.estado);
  bool get _blocked =>
      widget.isBusy || widget.isLoading || widget.errorMessage != null;
  bool get _canReorder =>
      _canModify &&
      !_blocked &&
      widget.detalles.length > 1 &&
      widget.detalles.every((d) => d.id != null) &&
      widget.detalles.map((d) => d.id).toSet().length == widget.detalles.length;

  List<DetalleCarga> get _items {
    final ranks = {
      for (final (index, id) in (_draft ?? _order).indexed) id: index,
    };
    final source = widget.detalles.indexed.toList();
    source.sort(
      (a, b) => (ranks[a.$2.id] ?? ranks.length + a.$1).compareTo(
        ranks[b.$2.id] ?? ranks.length + b.$1,
      ),
    );
    return source.map((entry) => entry.$2).toList();
  }

  @override
  void didUpdateWidget(covariant CargaDetailsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.operation.id != widget.operation.id) {
      _order = [];
      _draft = null;
    } else if (!_canReorder ||
        oldWidget.detalles
            .map((d) => d.id)
            .toSet()
            .difference(widget.detalles.map((d) => d.id).toSet())
            .isNotEmpty ||
        widget.detalles
            .map((d) => d.id)
            .toSet()
            .difference(oldWidget.detalles.map((d) => d.id).toSet())
            .isNotEmpty) {
      _draft = null;
    }
  }

  void _reorder(int oldIndex, int newIndex) {
    if (_draft == null || !_canReorder) return;
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final id = _draft!.removeAt(oldIndex);
      _draft!.insert(newIndex, id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    final reordering = _draft != null;
    return Column(
      children: [
        if (widget.isBusy || widget.isLoading) const LinearProgressIndicator(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.onRefresh,
            notificationPredicate: (notification) =>
                !reordering && notification.depth == 0,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        OperacionCargaSummary(operation: widget.operation),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Detalles de carga (${items.length})',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            if (reordering) ...[
                              TextButton(
                                onPressed: () => setState(() => _draft = null),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => setState(() {
                                  _order = List.of(_draft!);
                                  _draft = null;
                                }),
                                child: const Text('Listo'),
                              ),
                            ] else ...[
                              if (_canModify)
                                TextButton.icon(
                                  onPressed: _blocked
                                      ? null
                                      : widget.onAddDetalle,
                                  icon: const Icon(Icons.add_rounded),
                                  label: const Text('Agregar'),
                                ),
                              if (_canReorder)
                                PopupMenuButton<String>(
                                  tooltip: 'Opciones de lista',
                                  icon: const Icon(Icons.more_vert_rounded),
                                  onSelected: (_) => setState(
                                    () => _draft = items
                                        .map((d) => d.id!)
                                        .toList(),
                                  ),
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                      value: 'reorder',
                                      child: Text('Reordenar'),
                                    ),
                                  ],
                                ),
                            ],
                          ],
                        ),
                        if (reordering)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Arrastra los agarres para ordenar. Este orden se mantiene mientras estás en esta pantalla.',
                            ),
                          ),
                        if (widget.errorMessage != null)
                          EmptyState(
                            message: widget.errorMessage!,
                            actionLabel: 'Reintentar',
                            onAction: widget.onRefresh,
                          )
                        else if (!widget.isLoading && items.isEmpty)
                          const EmptyState(
                            message: 'Esta operación aún no tiene detalles.',
                          ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverReorderableList(
                    itemCount: items.length,
                    onReorder: _reorder,
                    itemBuilder: (context, index) {
                      final detalle = items[index];
                      final canEdit =
                          _canModify &&
                          !_blocked &&
                          detalle.id != null &&
                          !reordering;
                      return Material(
                        key: detalle.id == null
                            ? ObjectKey(detalle)
                            : ValueKey(detalle.id),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: DetalleCargaRow(
                          item: detalle,
                          dragHandle: !reordering
                              ? null
                              : ReorderableDragStartListener(
                                  index: index,
                                  child: const Tooltip(
                                    message: 'Arrastrar para reordenar',
                                    child: SizedBox(
                                      width: 20,
                                      height: 48,
                                      child: Icon(
                                        Icons.drag_indicator,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                          onEditCalidad: canEdit
                              ? (calidad) =>
                                    widget.onEditCalidad(detalle, calidad)
                              : null,
                          onEdit: canEdit
                              ? () => widget.onEditDetalle(detalle)
                              : null,
                          onDelete: canEdit
                              ? () => widget.onDeleteDetalle(detalle)
                              : null,
                          onAddCalidad: canEdit
                              ? () => widget.onAddCalidad(detalle)
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: _canModify && !reordering
                        ? FilledButton.icon(
                            onPressed: _blocked || items.isEmpty
                                ? null
                                : widget.onFinalizar,
                            icon: const Icon(Icons.task_alt_rounded),
                            label: const Text('Finalizar operación'),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
