import 'package:flutter/material.dart';
import '../../../../../core/ui/cards/app_card.dart';
import '../../../../../core/ui/cards/app_card_header.dart';
import '../../../../../core/ui/cards/app_status_badge.dart';
import '../../domain/entities/distribucion_operacion.dart';
import 'reparto_avance.dart';
import 'reparto_operacion_card.dart';

class DistribucionResumenCard extends StatelessWidget {
  final DistribucionOperacion data;
  const DistribucionResumenCard({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    final o = data.operacion;
    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.local_shipping_rounded),
        title:
            '${o.camion?.placa ?? 'Camión #${o.idCamion}'} · ${repartoFecha(o.fechaCarga)}',
        subtitle:
            '${o.sedeOrigen?.nombre ?? 'Sede #${o.idSedeOrigen}'} → ${o.sedeDestino?.nombre ?? 'Sin destino definido'}',
        badge: AppStatusBadge(status: repartoOperacionStatus(o.estado)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${data.cargadas} jabas cargadas',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            '${data.cargas.length} cargas · ${data.productos} frutas distintas · ${data.asignaciones.length} asignaciones',
          ),
          const SizedBox(height: 18),
          RepartoAvance(
            label: 'Destinatarios definidos',
            cantidad: data.asignadas,
            total: data.cargadas,
            revisar: data.excesoAsignacion,
            pendiente: '${data.sinDestinatario} jabas sin destinatario',
          ),
          const SizedBox(height: 16),
          RepartoAvance(
            label: 'Calidades registradas',
            cantidad: data.clasificadas,
            total: data.cargadas,
            revisar: data.excesoClasificacion,
            pendiente: data.sinClasificar == null
                ? null
                : '${data.sinClasificar} jabas sin clasificar',
          ),
          if (data.desglosesPendientes > 0)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '${data.desglosesPendientes} asignaciones con desglose por calidad pendiente.',
              ),
            ),
          const SizedBox(height: 8),
          Text(
            'Asignar destinatarios no confirma la entrega física.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
