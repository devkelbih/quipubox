import 'package:flutter/material.dart';
import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';

import '../../domain/entities/detalle_carga.dart';

class DetalleCargaCard extends StatelessWidget {
  final DetalleCarga item;

  const DetalleCargaCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.inventory_2_rounded),
        title: 'Detalle #${item.id ?? '-'}',
        subtitle: '${item.cantidadJabas} jabas',
      ),
      body: AppCardBody(
        child: Column(
          children: [
            AppCardInfoRow(
              icon: Icons.person_outline_rounded,
              label: 'Cliente emisor',
              value: 'Cliente #${item.idClienteEmisor}',
            ),
            const SizedBox(height: 8),
            AppCardInfoRow(
              icon: Icons.eco_outlined,
              label: 'Fruta',
              value: 'Fruta #${item.idFruta}',
            ),
            const SizedBox(height: 8),
            AppCardInfoRow(
              icon: Icons.category_outlined,
              label: 'Variedad / tipo de jaba',
              value:
                  '${item.idVariedad == null ? 'Sin variedad' : 'Variedad #${item.idVariedad}'} · Tipo #${item.idTipoJaba}',
            ),
            if (item.esReparto) ...[
              const SizedBox(height: 8),
              AppCardInfoRow(
                icon: Icons.route_outlined,
                label: 'Reparto',
                value: item.idClienteReceptor == null
                    ? 'Pendiente de asignación'
                    : 'Cliente #${item.idClienteReceptor}',
              ),
            ],
            if (item.observaciones?.trim().isNotEmpty == true) ...[
              const SizedBox(height: 8),
              AppCardInfoRow(
                icon: Icons.notes_rounded,
                label: 'Observaciones',
                value: item.observaciones!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
