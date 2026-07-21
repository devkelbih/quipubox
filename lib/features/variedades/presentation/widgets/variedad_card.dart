import 'package:flutter/material.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_actions.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/status/app_status.dart';

import '../../domain/entities/variedad.dart';

class VariedadCard extends StatelessWidget {
  final Variedad item;
  final VoidCallback onEdit;
  final VoidCallback onChangeStatus;

  const VariedadCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final title =
        item.nombre.trim().isEmpty ? 'Variedad #${item.id ?? '-'}' : item.nombre;
    final subtitle =
        item.frutaNombre.trim().isNotEmpty == true ? item.frutaNombre : 'Sin fruta';
    final status = AppStatus.active(item.estado);

    final frutaText = item.frutaNombre.trim().isNotEmpty == true
        ? item.frutaNombre
        : 'Fruta #${item.idFruta}';
    final descripcion =
        item.descripcion?.trim().isNotEmpty == true ? item.descripcion : null;

    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.grain_rounded),
        title: title,
        subtitle: subtitle,
        status: status,
        badge: AppStatusBadge(status: status),
      ),
      body: AppCardBody(
        child: Column(
          children: [
            AppCardInfoRow(
              icon: Icons.eco_rounded,
              label: 'Fruta',
              value: frutaText,
            ),
            if (descripcion != null) ...[
              const SizedBox(height: 10),
              AppCardInfoRow(
                icon: Icons.notes_rounded,
                label: 'Descripción',
                value: descripcion,
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

