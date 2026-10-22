import 'package:flutter/material.dart';
import 'package:quipubox/core/common/string_extensions.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_actions.dart';
import 'package:quipubox/core/ui/cards/app_card_menu.dart';
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
  final VoidCallback? onRegisterVariedad;

  const FrutaCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onChangeStatus,
    this.onViewVariedades,
    this.onRegisterVariedad,
  });

  @override
  Widget build(BuildContext context) {
    final title = item.nombre.hasText
        ? item.nombre.value
        : 'Fruta #${item.id ?? '-'}';
    final descripcion = item.descripcion.value;
    final totalVariedades = item.totalVariedades;
    final variedadesText = switch (totalVariedades) {
      0 => 'Sin variedades registradas',
      1 => '1 variedad registrada',
      _ => '$totalVariedades variedades registradas',
    };
    final status = AppStatus.active(item.estado);

    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.eco_rounded),
        title: title,
        subtitle: variedadesText,
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
        navigationAction: totalVariedades > 0 && onViewVariedades != null
            ? AppCardQuickAction(
                icon: Icons.grass_rounded,
                label: 'Ver variedades',
                onPressed: onViewVariedades,
              )
            : null,
        operationalAction: AppCardQuickAction(
          icon: Icons.add_rounded,
          label: 'Registrar variedad',
          onPressed: onRegisterVariedad,
        ),
      ),
    );
  }
}
