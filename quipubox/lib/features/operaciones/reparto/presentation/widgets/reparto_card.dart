import 'package:flutter/material.dart';
import '../../../../../core/ui/cards/app_card.dart';
import '../../../../../core/ui/cards/app_card_header.dart';
import '../../../../../core/ui/cards/app_card_info_grid.dart';
import '../../../../../core/ui/cards/app_card_info_row.dart';
import '../../domain/entities/reparto.dart';

class RepartoCard extends StatelessWidget {
  final Reparto item;
  final VoidCallback onOpen;
  const RepartoCard({super.key, required this.item, required this.onOpen});
  @override
  Widget build(BuildContext context) => AppCard(
    header: AppCardHeader(
      icon: const Icon(Icons.local_shipping_outlined),
      title: item.receptor?.nombreCompleto ?? 'Receptor #${item.receptorId}',
      subtitle:
          'Puesto ${item.puesto?.numeroPuesto ?? item.puestoId.toString()}${item.seccion == null ? '' : ' · ${item.seccion}'}',
    ),
    body: AppCardInfoGrid(
      children: [
        AppCardInfoRow(
          icon: Icons.inventory_2_outlined,
          label: 'Asignadas',
          value: '${item.cantidad} jabas',
        ),
        AppCardInfoRow(
          icon: Icons.category_outlined,
          label: 'Desglose por calidad',
          value: '${item.cantidadDesglosada} de ${item.cantidad}',
        ),
      ],
    ),
    actions: Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: onOpen,
        icon: const Icon(Icons.chevron_right_rounded),
        label: const Text('Ver reparto'),
      ),
    ),
  );
}
