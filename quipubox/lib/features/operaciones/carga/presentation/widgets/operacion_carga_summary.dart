import 'package:flutter/material.dart';
import '../../../../../core/ui/cards/app_card.dart';
import '../../../../../core/ui/cards/app_card_body.dart';
import '../../../../../core/ui/cards/app_card_header.dart';
import '../../../../../core/ui/cards/app_card_info_grid.dart';
import '../../../../../core/ui/cards/app_card_info_row.dart';
import '../../../../../core/ui/cards/app_status_badge.dart';
import '../../domain/entities/operacion_carga.dart';
import 'estado_operacion_carga_ui.dart';

class OperacionCargaSummary extends StatelessWidget {
  final OperacionCarga operation;

  const OperacionCargaSummary({super.key, required this.operation});

  @override
  Widget build(BuildContext context) {
    final status = operation.estadoEnum.status;
    final nombreOrigen =
        operation.sedeOrigen?.nombre ?? 'Sede #${operation.idSedeOrigen}';
    final nombreDestino = operation.idSedeDestino != null
        ? (operation.sedeDestino?.nombre ?? 'Sede #${operation.idSedeDestino}')
        : 'Sin destino';
    final placaCamion =
        operation.camion?.placa ?? 'Camión #${operation.idCamion}';
    final nombreEncargado = operation.encargadoCarga != null
        ? '${operation.encargadoCarga!.nombres} ${operation.encargadoCarga!.apellidos ?? ''}'
              .trim()
        : 'Usuario #${operation.idEncargadoCarga}';
    final nombreRepartidor = operation.repartidorAsignado != null
        ? '${operation.repartidorAsignado!.nombres} ${operation.repartidorAsignado!.apellidos ?? ''}'
              .trim()
        : 'Usuario #${operation.idRepartidorAsignado}';

    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.local_shipping_rounded),
        title: '$nombreOrigen → $nombreDestino',
        subtitle:
            '${_dateText(operation.fechaCarga)} ${operation.horaCarga ?? ''}'
                .trim(),
        status: status,
        badge: AppStatusBadge(status: status),
      ),
      body: AppCardBody(
        child: Column(
          children: [
            AppCardInfoGrid(
              children: [
                AppCardInfoRow(
                  icon: Icons.local_shipping_outlined,
                  label: 'Camión',
                  value: placaCamion,
                ),
                if (operation.idEncargadoCarga != null) ...[
                  AppCardInfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Encargado',
                    value: nombreEncargado,
                  ),
                ],
              ],
            ),

            if (operation.idRepartidorAsignado != null) ...[
              const SizedBox(height: 8),
              AppCardInfoRow(
                icon: Icons.delivery_dining_rounded,
                label: 'Repartidor',
                value: nombreRepartidor,
              ),
            ],

            if (operation.observaciones?.trim().isNotEmpty == true) ...[
              const SizedBox(height: 8),
              AppCardInfoRow(
                icon: Icons.notes_rounded,
                label: 'Observaciones',
                value: operation.observaciones!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _dateText(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
