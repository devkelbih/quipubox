import 'package:flutter/material.dart';
import '../../../../../core/ui/cards/app_card.dart';
import '../../../../../core/ui/cards/app_card_header.dart';
import '../../../carga/domain/entities/detalle_carga.dart';
import '../../domain/entities/reparto.dart';
import 'reparto_avance.dart';

class RepartoCargaCard extends StatelessWidget {
  final DetalleCarga carga;
  final List<Reparto> asignaciones;
  final VoidCallback onOpen;
  const RepartoCargaCard({
    super.key,
    required this.carga,
    required this.asignaciones,
    required this.onOpen,
  });
  @override
  Widget build(BuildContext context) {
    final asignadas = asignaciones.fold<int>(0, (n, a) => n + a.cantidad);
    final faltan = (carga.cantidadJabas - asignadas).clamp(
      0,
      carga.cantidadJabas,
    );
    final directo = !carga.esReparto && asignaciones.length == 1
        ? asignaciones.single
        : null;
    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.inventory_2_outlined),
        title:
            '${carga.cantidadJabas} jabas · ${carga.fruta?.nombre ?? 'Fruta #${carga.idFruta}'}${carga.variedad == null ? '' : ' (${carga.variedad!.nombre})'}',
        subtitle:
            '${carga.clienteEmisor?.nombreCompleto ?? 'Emisor #${carga.idClienteEmisor}'} · ${carga.esReparto ? 'Distribución posterior' : 'Entrega directa'}',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (directo != null) ...[
            Text(
              'Destino: ${directo.receptor?.nombreCompleto ?? 'Receptor #${directo.receptorId}'} · Puesto ${directo.puesto?.numeroPuesto ?? directo.puestoId.toString()}',
            ),
            const SizedBox(height: 12),
          ],
          RepartoAvance(
            label: 'Destinatarios',
            cantidad: asignadas,
            total: carga.cantidadJabas,
            revisar: asignadas > carga.cantidadJabas,
            pendiente: faltan == 0
                ? 'Destinatario definido para toda la carga'
                : 'Faltan $faltan jabas por asignar',
          ),
          const SizedBox(height: 12),
          RepartoAvance(
            label: 'Calidades',
            cantidad: carga.cantidadClasificada,
            total: carga.cantidadJabas,
            revisar: (carga.cantidadClasificada ?? 0) > carga.cantidadJabas,
            pendiente: carga.cantidadClasificada == null
                ? null
                : 'Faltan ${(carga.cantidadJabas - carga.cantidadClasificada!).clamp(0, carga.cantidadJabas)} jabas por clasificar',
          ),
        ],
      ),
      actions: Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: onOpen,
          icon: const Icon(Icons.chevron_right_rounded),
          label: const Text('Gestionar distribución'),
        ),
      ),
    );
  }
}
