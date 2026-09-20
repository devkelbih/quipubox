import 'package:flutter/material.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_actions.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/status/app_status.dart';

import '../../domain/entities/puesto.dart';

class PuestoCard extends StatelessWidget {
  final Puesto item;
  final VoidCallback onEdit;
  final VoidCallback onChangeStatus;

  const PuestoCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final numero = item.numeroPuesto.trim().isEmpty
        ? 'Puesto #${item.id ?? '-'}'
        : 'Puesto ${item.numeroPuesto.trim()}';

    final lugar = item.lugarNombre.trim().isNotEmpty
        ? item.lugarNombre.trim()
        : 'Sin lugar operativo';

    final sede = item.sedeNombre.trim().isNotEmpty
        ? item.sedeNombre.trim()
        : 'Sin sede';

    final referencia = item.referencia?.trim().isNotEmpty == true
        ? item.referencia!.trim()
        : null;

    final tipoLugar = item.lugarOperativo?.tipoLugar.name;

    final status = AppStatus.active(item.estado);

    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.storefront_rounded),
        title: numero,
        subtitle: lugar,
        status: status,
        badge: AppStatusBadge(status: status),
      ),
      body: AppCardBody(
        child: Column(
          children: [
            AppCardInfoRow(
              icon: Icons.location_on_rounded,
              label: 'Sede',
              value: sede,
            ),
            if (tipoLugar != null && tipoLugar.trim().isNotEmpty)
              AppCardInfoRow(
                icon: Icons.place_rounded,
                label: 'Tipo de lugar',
                value: tipoLugar,
              ),
            if (referencia != null)
              AppCardInfoRow(
                icon: Icons.notes_rounded,
                label: 'Referencia',
                value: referencia,
              ),
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
