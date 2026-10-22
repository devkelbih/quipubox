import 'package:flutter/material.dart';
import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_actions.dart';
import 'package:quipubox/core/ui/cards/app_card_info_grid.dart';
import 'package:quipubox/core/ui/cards/app_card_menu.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';

import '../../domain/entities/operacion_carga.dart';
import '../../domain/enums/estado_operacion_carga.dart';
import 'estado_operacion_carga_ui.dart';

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
    final estado = item.estadoEnum;
    final status = estado.status;

    // Reglas de negocio
    final canEdit =
        estado == EstadoOperacionCarga.pendiente ||
        estado == EstadoOperacionCarga.enCurso;
    final canAssign =
        (estado == EstadoOperacionCarga.pendiente ||
            estado == EstadoOperacionCarga.enCurso ||
            estado == EstadoOperacionCarga.enTransito) &&
        item.id != null;

    final origen = item.sedeOrigen?.nombre ?? 'Sede #${item.idSedeOrigen}';
    final destino =
        item.sedeDestino?.nombre ?? 'Lugar #${item.idSedeDestino ?? '-'}';

    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.local_shipping_rounded),
        title: 'Operación #${item.id ?? '-'}',
        subtitle: _dateText(item.fechaCarga),
        status: status,
        badge: AppStatusBadge(status: status),
        menu: AppCardMenu(
          actions: [
            AppCardMenuAction(
              icon: Icons.edit_rounded,
              label: 'Editar',
              onSelected: onEdit,
              enabled: canEdit,
            ),
          ],
        ),
      ),
      body: AppCardBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCardInfoGrid(
              children: [
                // 1. Ruta (Origen -> Destino)
                AppCardInfoRow(
                  icon: Icons.route_rounded,
                  label: 'Ruta',
                  value: '$origen  →  $destino',
                ),

                // 2. Camión
                AppCardInfoRow(
                  icon: Icons.local_shipping_outlined,
                  label: 'Camión',
                  value: item.camion?.placa ?? 'Camión #${item.idCamion}',
                ),
              ],
            ),
            SizedBox(height: 8.0),
            // 3. Detalles de Carga (Navega al detalle)
            AppCardInfoRow(
              icon: Icons.inventory_2_outlined,
              label: 'Encargado de carga',
              value:
                  item.encargadoCarga?.nombreCompleto ?? 'Usuario #${item.idEncargadoCarga}',
            ),
          ],
        ),
      ),
      actions: AppCardActions(
        navigationAction: AppCardQuickAction(
          icon: Icons.inventory_2_outlined,
          label: 'Ver detalles',
          onPressed: onOpen,
        ),
        operationalAction: AppCardQuickAction(
          icon: Icons.note_alt_outlined,
          label: 'Asignar carga',
          onPressed: canAssign ? onAssignCarga : null,
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
