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
  final VoidCallback onAssignCarga;

  const CargaCard({
    super.key,
    required this.item,
    required this.onOpen,
    required this.onEdit,
    required this.onAssignCarga,
  });

  @override
  Widget build(BuildContext context) {
    final status = AppStatus(
      label: item.estadoEnum.label,
      type: statusFor(item.estado).type,
    );

    // Reglas de negocio
    final canEdit = item.estado == 'pendiente' || item.estado == 'en_curso';
    final canAssign =
        (item.estado == 'pendiente' ||
            item.estado == 'en_curso' ||
            item.estado == 'en_transito') &&
        item.id != null;

    final origen = item.sedeOrigen?.nombre ?? 'Sede #${item.idSedeOrigen}';
    final destino = item.sedeDestino?.nombre ?? 'Lugar #${item.idSedeDestino ?? '-'}';

    // Obtenemos la cantidad real de registros de detalle
    final cantidadDetalles = item.detalles?.length ?? 0;

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
            // 1. Ruta (Origen -> Destino)
            AppCardInfoRow(
              icon: Icons.route_rounded,
              label: 'Ruta',
              value: '$origen  →  $destino',
            ),
            const SizedBox(height: 8),

            // 2. Camión
            AppCardInfoRow(
              icon: Icons.local_shipping_outlined,
              label: 'Camión',
              value: item.camion?.placa ?? 'Camión #${item.idCamion}',
            ),
            const SizedBox(height: 8),

            // 3. Detalles de Carga (Navega al detalle)
            AppCardInfoRow(
              icon: Icons.inventory_2_outlined,
              label: 'Detalles de carga',
              value: '$cantidadDetalles registro${cantidadDetalles == 1 ? '' : 's'}',
              onTap: onOpen, // <-- Aquí se activa la flechita y la navegación
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
          onPressed: canAssign ? onAssignCarga : null,
          icon: const Icon(Icons.note_alt_outlined, size: 18),
          label: const Text('Asignar Carga'),
        ),
      ),
    );
  }

  static AppStatus statusFor(String value) {
    return switch (value) {
      'pendiente' => const AppStatus(label: 'Pendiente', type: AppStatusType.warning),
      'en_curso' => const AppStatus(label: 'En curso', type: AppStatusType.info),
      'en_transito' => const AppStatus(label: 'En tránsito', type: AppStatusType.info),
      'repartiendo' => const AppStatus(label: 'Repartiendo', type: AppStatusType.success),
      'completado' => const AppStatus(label: 'Completado', type: AppStatusType.neutral),
      _ => AppStatus(label: value, type: AppStatusType.neutral),
    };
  }

  static String _dateText(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}