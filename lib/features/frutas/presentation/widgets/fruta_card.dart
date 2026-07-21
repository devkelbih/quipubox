import 'package:flutter/material.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_actions.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/status/app_status.dart';

import '../../domain/entities/fruta.dart';

class FrutaCard extends StatelessWidget {
  final Fruta item;
  final VoidCallback onEdit;
  final VoidCallback onChangeStatus;

  const FrutaCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final title =
        item.nombre.trim().isEmpty ? 'Fruta #${item.id ?? '-'}' : item.nombre;
    final descripcion =
        item.descripcion?.trim().isNotEmpty == true ? item.descripcion : null;
    final subtitle = descripcion ?? 'Sin descripción';
    final status = AppStatus.active(item.estado);

    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.eco_rounded),
        title: title,
        subtitle: subtitle,
        status: status,
        badge: AppStatusBadge(status: status),
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

