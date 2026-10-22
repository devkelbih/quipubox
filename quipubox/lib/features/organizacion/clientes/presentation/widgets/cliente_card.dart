import 'package:flutter/material.dart';
import 'package:quipubox/core/common/string_extensions.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_info_grid.dart';
import 'package:quipubox/core/ui/cards/app_card_menu.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/status/app_status.dart';

import '../../domain/entities/cliente.dart';

class ClienteCard extends StatelessWidget {
  final Cliente item;

  final VoidCallback? onEdit;
  final VoidCallback? onChangeStatus;

  // Callbacks para las opciones de gestión del menú.
  final VoidCallback? onManageSedes;
  final VoidCallback? onManagePuestos;

  const ClienteCard({
    super.key,
    required this.item,
    this.onEdit,
    this.onChangeStatus,
    this.onManageSedes,
    this.onManagePuestos,
  });

  @override
  Widget build(BuildContext context) {
    final title = item.nombreCompleto.hasText
        ? item.nombreCompleto.value
        : 'Cliente #${item.id ?? '-'}';

    final apodo = item.apodo.value;
    final telefono = item.telefono.value;

    // El subtítulo es exclusivamente para el apodo
    final subtitle = apodo;

    final status = AppStatus.active(item.estado);

    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.person_rounded),
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
            AppCardMenuAction(
              icon: Icons.business_rounded,
              label: 'Gestionar sedes',
              // TODO: Conectar la gestión de sedes desde la lista de clientes.
              onSelected: onManageSedes,
            ),
            AppCardMenuAction(
              icon: Icons.storefront_rounded,
              label: 'Gestionar puestos',
              // TODO: Conectar la gestión de puestos desde la lista de clientes.
              onSelected: onManagePuestos,
            ),
          ],
        ),
      ),
      body: telefono == null && item.sedes.isEmpty && item.puestos.isEmpty
          ? null
          : AppCardBody(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCardInfoGrid(
                    children: [
                      if (telefono != null)
                        AppCardInfoRow(
                          icon: Icons.phone_rounded,
                          label: 'Teléfono',
                          value: telefono,
                        ),
                      if (item.sedes.isNotEmpty)
                        AppCardInfoRow(
                          icon: Icons.business_rounded,
                          label: 'Sedes',
                          value: item.sedes
                              .map((relacion) {
                                final nombre =
                                    relacion.sede?.nombre.value ??
                                    'Sede #${relacion.idSede}';
                                return '$nombre · ${relacion.tipoRelacion.label}';
                              })
                              .join('\n'),
                        ),
                    ],
                  ),
                  if (item.puestos.isNotEmpty)
                    AppCardInfoRow(
                      icon: Icons.storefront_rounded,
                      label: 'Puestos',
                      value: item.puestos
                          .map((relacion) {
                            final puesto = relacion.puesto;
                            final lugar =
                                puesto?.lugarOperativo?.nombre.value ??
                                'Lugar #${puesto?.idLugar ?? relacion.idPuesto}';
                            final numero =
                                puesto?.numeroPuesto.value ??
                                '#${relacion.idPuesto}';
                            return '$lugar · Puesto $numero';
                          })
                          .join('\n'),
                    ),
                ],
              ),
            ),
    );
  }
}
