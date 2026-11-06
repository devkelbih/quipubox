import 'package:flutter/material.dart';
import '../../../../../core/ui/cards/app_card.dart';
import '../../../../../core/ui/cards/app_card_header.dart';
import '../../../../../core/ui/cards/app_card_info_row.dart';
import '../../../../../core/ui/cards/app_status_badge.dart';
import '../../../../../core/ui/status/app_status.dart';
import '../../../../../core/ui/status/app_status_colors.dart';
import '../../../carga/domain/entities/operacion_carga.dart';

AppStatus repartoOperacionStatus(String estado) => AppStatus(
  label: switch (estado) {
    'pendiente' => 'Pendiente',
    'en_curso' => 'En curso',
    'en_transito' => 'En tránsito',
    'repartiendo' => 'Repartiendo',
    'completado' => 'Completado',
    'cancelada' || 'cancelado' => 'Cancelado',
    _ => estado,
  },
  type: switch (estado) {
    'cancelada' || 'cancelado' => AppStatusType.danger,
    'pendiente' => AppStatusType.warning,
    'completado' => AppStatusType.success,
    _ => AppStatusType.info,
  },
);
String repartoFecha(DateTime fecha) =>
    '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';

class RepartoOperacionCard extends StatelessWidget {
  final OperacionCarga item;
  final VoidCallback onOpen;
  const RepartoOperacionCard({
    super.key,
    required this.item,
    required this.onOpen,
  });
  @override
  Widget build(BuildContext context) => AppCard(
    header: AppCardHeader(
      icon: const Icon(Icons.local_shipping_rounded),
      title:
          'Operación #${item.id} · ${item.camion?.placa ?? 'Camión #${item.idCamion}'}',
      subtitle: repartoFecha(item.fechaCarga),
      badge: AppStatusBadge(status: repartoOperacionStatus(item.estado)),
    ),
    body: AppCardInfoRow(
      icon: Icons.route_rounded,
      label: 'Ruta',
      value:
          '${item.sedeOrigen?.nombre ?? 'Sede #${item.idSedeOrigen}'} → ${item.sedeDestino?.nombre ?? (item.idSedeDestino == null ? 'Sin destino definido' : 'Sede #${item.idSedeDestino}')}',
    ),
    actions: Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: onOpen,
        icon: const Icon(Icons.chevron_right_rounded),
        label: const Text('Ver distribución'),
      ),
    ),
  );
}
