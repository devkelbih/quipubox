import 'package:flutter/material.dart';
import 'package:quipubox/core/common/string_extensions.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_actions.dart';
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

      actions: AppCardActions(
        secondaryAction: OutlinedButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_rounded, size: 18),
          label: const Text('Editar'),
        ),
        primaryAction: FilledButton.tonalIcon(
          onPressed: onChangeStatus,
          icon: Icon(
            item.estado ? Icons.block_rounded : Icons.check_circle_rounded,
            size: 18,
          ),
          label: Text(item.estado ? 'Desactivar' : 'Activar'),
        ),
      ),
    );
  }
}
