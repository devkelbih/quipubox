import 'package:flutter/material.dart';
import 'package:quipubox/core/common/string_extensions.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_menu.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/status/app_status.dart';

import '../../domain/entities/camion.dart';

class CamionCard extends StatelessWidget {
  final Camion item;
  final VoidCallback onEdit;
  final VoidCallback onChangeStatus;

  const CamionCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final placa = item.placa.value;
    final descripcion = item.descripcion.value;
    final observaciones = item.observaciones.value;
    final title = placa.hasText ? placa : 'Camión #${item.id}';

    final subtitle = descripcion ?? 'Sin descripción';
    final status = AppStatus.active(item.estado);
    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.local_shipping_rounded),
        title: title,
        subtitle: subtitle,
        status: status,
        badge: AppStatusBadge(status: status),
        menu: AppCardMenu(
          actions: [
            AppCardMenuAction(
              icon: Icons.edit_rounded,
              label: 'Editar',
              onSelected: onEdit,
            ),
            AppCardMenuAction(
              icon: item.estado
                  ? Icons.block_rounded
                  : Icons.check_circle_rounded,
              label: item.estado ? 'Desactivar' : 'Activar',
              onSelected: onChangeStatus,
            ),
          ],
        ),
      ),

      body: observaciones == null
          ? null
          : AppCardBody(
              child: AppCardInfoRow(
                icon: Icons.notes_rounded,
                label: 'Observaciones',
                value: observaciones,
              ),
            ),
    );
  }
}
