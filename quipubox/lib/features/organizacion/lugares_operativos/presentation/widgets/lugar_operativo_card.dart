import 'package:flutter/material.dart';
import 'package:quipubox/core/common/string_extensions.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_menu.dart';
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
    final title = !item.nombre.hasText
        ? 'Lugar operativo #${item.id}'
        : item.nombre;

    final subtitle = item.tipoLugar.label;
    final status = AppStatus.active(item.estado);

    final hasDireccion = item.direccionReferencia.hasText;

    final hasObservaciones = item.observaciones.hasText;

    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.warehouse_rounded),
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
      body: AppCardBody(
        child: Column(
          children: [
            AppCardInfoRow(
              icon: Icons.business_rounded,
              label: 'Sede',
              value: item.sede?.nombre.value ?? 'Sin sede',
            ),
            if (hasDireccion) ...[
              const SizedBox(height: 10),
              AppCardInfoRow(
                icon: Icons.place_rounded,
                label: 'Dirección',
                value: item.direccionReferencia!.value,
              ),
            ],
            if (hasObservaciones) ...[
              const SizedBox(height: 10),
              AppCardInfoRow(
                icon: Icons.notes_rounded,
                label: 'Observaciones',
                value: item.observaciones!.value,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
