import 'package:flutter/material.dart';
import 'package:quipubox/core/common/string_extensions.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_actions.dart';
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
    final title = item.nombre.hasText
        ? item.nombre.value
        : 'Sede #${item.id}';
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
