import 'package:flutter/material.dart';
import '../../../../../core/ui/cards/app_card.dart';
import '../../../../../core/ui/cards/app_card_header.dart';
import '../../domain/entities/reparto.dart';

class RepartoAsignacionCard extends StatelessWidget {
  final Reparto item;
  final bool editable;
  final bool enabled;
  final bool canAddLinea;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddLinea;
  final ValueChanged<RepartoLinea> onEditLinea;
  final ValueChanged<RepartoLinea> onDeleteLinea;
  const RepartoAsignacionCard({
    super.key,
    required this.item,
    required this.editable,
    required this.enabled,
    required this.canAddLinea,
    required this.onEdit,
    required this.onDelete,
    required this.onAddLinea,
    required this.onEditLinea,
    required this.onDeleteLinea,
  });
  @override
  Widget build(BuildContext context) {
    final canModify = editable && !item.protegido;
    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.person_outline_rounded),
        title: item.receptor?.nombreCompleto ?? 'Receptor #${item.receptorId}',
        subtitle:
            'Puesto ${item.puesto?.numeroPuesto ?? item.puestoId.toString()}${item.seccion == null ? '' : ' · ${item.seccion}'}${item.orden == null ? '' : ' · Orden ${item.orden}'}',
        menu: !canModify
            ? null
            : PopupMenuButton<String>(
                tooltip: 'Opciones de asignación',
                enabled: enabled,
                onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Editar asignación'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Eliminar asignación'),
                  ),
                ],
              ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${item.cantidad} jabas asignadas · ${item.cantidadDesglosada} con desglose',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (item.cantidadDesglosada != item.cantidad)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                item.cantidadDesglosada < item.cantidad
                    ? 'Falta desglosar ${item.cantidad - item.cantidadDesglosada} jabas de esta asignación.'
                    : 'Revisar: el desglose supera la cantidad asignada.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (item.protegido)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Asignación con entregas o guía emitida.'),
            ),
          if (item.observaciones?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(item.observaciones!),
            ),
          for (final l in item.lineas)
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '${l.nombre ?? 'Calidad #${l.idCalidadCarga}'} · ${l.cantidad} jabas${l.precio == null ? '' : ' · ${l.precio!.toStringAsFixed(2)} c/u'}',
                    ),
                  ),
                ),
                if (canModify && l.id != null)
                  PopupMenuButton<String>(
                    tooltip: 'Opciones de calidad asignada',
                    enabled: enabled,
                    onSelected: (action) =>
                        action == 'edit' ? onEditLinea(l) : onDeleteLinea(l),
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Editar cantidad y precio'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Eliminar calidad'),
                      ),
                    ],
                  ),
              ],
            ),
        ],
      ),
      actions: !canModify
          ? null
          : Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: enabled && canAddLinea ? onAddLinea : null,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Completar desglose'),
              ),
            ),
    );
  }
}
