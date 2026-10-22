import 'package:flutter/material.dart';
import 'package:quipubox/core/common/string_extensions.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_menu.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/status/app_status.dart';

import '../../domain/entities/sede.dart';
import '../../domain/enums/tipo_sede.dart';

class SedeCard extends StatelessWidget {
  final Sede item;
  final VoidCallback onEdit;
  final VoidCallback onChangeStatus;

  const SedeCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final title = item.nombre.hasText ? item.nombre.value : 'Sede #${item.id}';
    final subtitle = item.tipoSede.label;
    final status = AppStatus.active(item.estado);

    final location = _locationText(item);
    final direccion = item.direccion.value;
    final hasBody = location != null || direccion != null;

    return AppCard(
      header: AppCardHeader(
        icon: Icon(_iconByType(item.tipoSede)),
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
      body: !hasBody
          ? null
          : AppCardBody(
              child: Column(
                children: [
                  if (location != null)
                    AppCardInfoRow(
                      icon: Icons.map_rounded,
                      label: 'Ubicación',
                      value: location,
                    ),
                  if (location != null && direccion != null)
                    const SizedBox(height: 10),
                  if (direccion != null)
                    AppCardInfoRow(
                      icon: Icons.place_rounded,
                      label: 'Dirección',
                      value: direccion,
                    ),
                ],
              ),
            ),
    );
  }

  static String? _locationText(Sede item) {
    final ciudad = item.ciudad?.value;
    final departamento = item.departamento?.value;

    if (ciudad.hasText && departamento.hasText) {
      if (ciudad!.toLowerCase() == departamento!.toLowerCase()) {
        return ciudad;
      }
      return '$ciudad, $departamento';
    }

    if (ciudad.hasText) return ciudad;
    if (departamento.hasText) return departamento;

    return null;
  }

  static IconData _iconByType(TipoSede value) {
    switch (value) {
      case TipoSede.origen:
        return Icons.upload_rounded;
      case TipoSede.destino:
        return Icons.download_rounded;
      case TipoSede.ambos:
        return Icons.sync_alt_rounded;
    }
  }
}
