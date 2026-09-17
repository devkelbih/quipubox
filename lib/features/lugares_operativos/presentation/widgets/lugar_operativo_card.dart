import 'package:flutter/material.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_actions.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/status/app_status.dart';

import '../../domain/entities/lugar_operativo.dart';

class LugarOperativoCard extends StatelessWidget {
  final LugarOperativo item;

  final VoidCallback? onEdit;
  final VoidCallback? onChangeStatus;

  const LugarOperativoCard({
    super.key,
    required this.item,
    this.onEdit,
    this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final title = item.nombre.isEmpty
        ? 'Lugar operativo #${item.id}'
        : item.nombre;

    final subtitle = item.tipoLugar.label;
    final status = AppStatus.active(item.estado);

    final hasDireccion = item.direccionReferencia?.trim().isNotEmpty ?? false;

    final hasObservaciones = item.observaciones?.trim().isNotEmpty ?? false;

    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.warehouse_rounded),
        title: title,
        subtitle: subtitle,
        status: status,
        badge: AppStatusBadge(status: status),
      ),
      body: AppCardBody(
        child: Column(
          children: [
            AppCardInfoRow(
              icon: Icons.business_rounded,
              label: 'Sede',
              value: item.sede?.nombre.trim() ?? 'Sin sede',
            ),
            if (hasDireccion) ...[
              const SizedBox(height: 10),
              AppCardInfoRow(
                icon: Icons.place_rounded,
                label: 'Dirección',
                value: item.direccionReferencia!.trim(),
              ),
            ],
            if (hasObservaciones) ...[
              const SizedBox(height: 10),
              AppCardInfoRow(
                icon: Icons.notes_rounded,
                label: 'Observaciones',
                value: item.observaciones!.trim(),
              ),
            ],
          ],
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
