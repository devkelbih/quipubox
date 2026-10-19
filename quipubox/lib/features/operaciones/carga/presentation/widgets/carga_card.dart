import 'package:flutter/material.dart';
import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_actions.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/status/app_status.dart';
import 'package:quipubox/core/ui/status/app_status_colors.dart';

import '../../domain/entities/operacion_carga.dart';

class CargaCard extends StatelessWidget {
  final OperacionCarga item;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  const CargaCard({
    super.key,
    required this.item,
    required this.onOpen,
    required this.onEdit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final status = statusFor(item.estado);
    final canCancel =
        item.estado != 'cancelada' &&
        item.estado != 'repartiendo' &&
        item.id != null;
    final canEdit = item.estado != 'cancelada' && item.estado != 'repartiendo';

    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.local_shipping_rounded),
        title: 'Operación #${item.id ?? '-'}',
        subtitle: _dateText(item.fechaCarga),
        status: status,
        badge: AppStatusBadge(status: status),
      ),
      body: AppCardBody(
        child: Column(
          children: [
            AppCardInfoRow(
              icon: Icons.trip_origin_rounded,
              label: 'Sede de origen',
              value: 'Sede #${item.idSedeOrigen}',
            ),
            const SizedBox(height: 8),
            AppCardInfoRow(
              icon: Icons.local_shipping_outlined,
              label: 'Camión',
              value: 'Camión #${item.idCamion}',
            ),
            const SizedBox(height: 8),
            AppCardInfoRow(
              icon: Icons.inventory_2_outlined,
              label: 'Detalles de carga',
              value: '${item.detalles?.length ?? 0} detalles · Ver operación',
              onTap: onOpen,
            ),
          ],
        ),
      ),
      actions: AppCardActions(
        secondaryAction: OutlinedButton.icon(
          onPressed: canEdit ? onEdit : null,
          icon: const Icon(Icons.edit_rounded, size: 18),
          label: const Text('Editar'),
        ),
        primaryAction: FilledButton.tonalIcon(
          onPressed: canCancel ? onCancel : null,
          icon: const Icon(Icons.cancel_outlined, size: 18),
          label: const Text('Cancelar'),
        ),
      ),
    );
  }

  static AppStatus statusFor(String value) {
    return switch (value) {
      'pendiente' => const AppStatus(
        label: 'Pendiente',
        type: AppStatusType.warning,
      ),
      'en_curso' => const AppStatus(
        label: 'En curso',
        type: AppStatusType.info,
      ),
      'repartiendo' => const AppStatus(
        label: 'Repartiendo',
        type: AppStatusType.success,
      ),
      'cancelada' => const AppStatus(
        label: 'Cancelada',
        type: AppStatusType.danger,
      ),
      _ => AppStatus(label: value, type: AppStatusType.neutral),
    };
  }

  static String _dateText(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
