import 'package:flutter/material.dart';

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
    final title = item.nombre.isEmpty ? 'Sede #${item.id}' : item.nombre;
    final subtitle = item.tipoSede.label;
    final status = AppStatus.active(item.estado);

    final location = _locationText(item);
    final hasDireccion =
        item.direccion != null && item.direccion!.trim().isNotEmpty;
    final hasBody = location != null || hasDireccion;

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
                  if (location != null && hasDireccion)
                    const SizedBox(height: 10),
                  if (hasDireccion)
                    AppCardInfoRow(
                      icon: Icons.place_rounded,
                      label: 'Dirección',
                      value: item.direccion!,
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
    final ciudad = item.ciudad?.trim();
    final departamento = item.departamento?.trim();

    if (_hasText(ciudad) && _hasText(departamento)) {
      if (ciudad!.toLowerCase() == departamento!.toLowerCase()) {
        return ciudad;
      }
      return '$ciudad, $departamento';
    }

    if (_hasText(ciudad)) return ciudad;
    if (_hasText(departamento)) return departamento;

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

  static bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}