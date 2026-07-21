import 'package:flutter/material.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_actions.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/status/app_status.dart';

import '../../domain/entities/tipos_jaba.dart';
import '../../domain/enums/tipo_material_jaba.dart';

class TipoJabaCard extends StatelessWidget {
  final TipoJaba item;
  final VoidCallback onEdit;
  final VoidCallback onChangeStatus;

  const TipoJabaCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final title =
        item.nombre.trim().isEmpty ? 'Tipo de jaba #${item.id ?? '-'}' : item.nombre;
    final subtitle = item.tipoMaterial.label;
    final status = AppStatus.active(item.estado);

    final descripcion =
        item.descripcion?.trim().isNotEmpty == true ? item.descripcion : null;

    return AppCard(
      header: AppCardHeader(
        icon: Icon(_materialIcon(item.tipoMaterial)),
        title: title,
        subtitle: subtitle,
        status: status,
        badge: AppStatusBadge(status: status),
      ),
      body: descripcion == null
          ? null
          : AppCardBody(
              child: AppCardInfoRow(
                icon: Icons.notes_rounded,
                label: 'Descripción',
                value: descripcion,
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

  static IconData _materialIcon(TipoMaterialJaba material) {
    switch (material) {
      case TipoMaterialJaba.madera:
        return Icons.forest_rounded;
      case TipoMaterialJaba.plastico:
        return Icons.inventory_2_rounded;
    }
  }
}

