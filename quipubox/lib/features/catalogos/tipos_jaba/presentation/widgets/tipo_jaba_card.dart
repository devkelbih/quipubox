import 'package:flutter/material.dart';
import 'package:quipubox/core/common/string_extensions.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_menu.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/status/app_status.dart';

import '../../domain/entities/tipos_jaba.dart';
import '../../domain/enums/tipo_material_jaba.dart';

class TipoJabaCard extends StatelessWidget {
  final TiposJaba item;
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
    final title = item.nombre.hasText
        ? item.nombre.value
        : 'Tipo de jaba #${item.id ?? '-'}';
    final subtitle = item.tipoMaterial.label;
    final status = AppStatus.active(item.estado);

    final descripcion = item.descripcion.value;

    return AppCard(
      header: AppCardHeader(
        icon: Icon(_materialIcon(item.tipoMaterial)),
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
      body: descripcion == null
          ? null
          : AppCardBody(
              child: AppCardInfoRow(
                icon: Icons.notes_rounded,
                label: 'Descripción',
                value: descripcion,
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
      case TipoMaterialJaba.carton:
        return Icons.archive_rounded;
    }
  }
}
