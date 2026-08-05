import 'package:flutter/material.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_actions.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/status/app_status.dart';

import '../../domain/entities/fruta.dart';

class FrutaCard extends StatelessWidget {
  final Fruta item;
  final VoidCallback onEdit;
  final VoidCallback onChangeStatus;
  final VoidCallback? onViewVariedades;

  const FrutaCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onChangeStatus,
    this.onViewVariedades,
  });

  @override
  Widget build(BuildContext context) {
    final title = item.nombre.trim().isEmpty
        ? 'Fruta #${item.id ?? '-'}'
        : item.nombre;
    final descripcion = item.descripcion?.trim().isNotEmpty == true
        ? item.descripcion
        : null;
    final totalVariedades = item.totalVariedades;
    final variedadesText = switch (totalVariedades) {
      0 => 'Sin variedades registradas',
      1 => '1 registrada',
      _ => '$totalVariedades registradas',
    };
    final status = AppStatus.active(item.estado);

    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.eco_rounded),
        title: title,
        status: status,
        badge: AppStatusBadge(status: status),
      ),
      body: AppCardBody(
        child: Column(
          children: [
            AppCardInfoRow(
              icon: Icons.grass_rounded,
              label: 'Variedades',
              value: variedadesText,
              onTap: totalVariedades > 0 ? onViewVariedades : null,
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
