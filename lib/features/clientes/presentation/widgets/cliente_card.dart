import 'package:flutter/material.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_actions.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/cards/app_card_tag_section.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/status/app_status.dart';
import 'package:quipubox/core/ui/tags/app_tag.dart';

import '../../domain/entities/cliente.dart';

class ClienteCard extends StatelessWidget {
  final Cliente item;

  final VoidCallback? onEdit;
  final VoidCallback? onChangeStatus;

  // Callbacks para gestionar sedes y puestos (activan las flechitas)
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
    final title = item.nombreCompleto.trim().isEmpty
        ? 'Cliente #${item.id ?? '-'}'
        : item.nombreCompleto.trim();

    final apodo = item.apodo?.trim();
    final hasApodo = apodo?.isNotEmpty == true;

    final telefono = item.telefono?.trim();
    final hasTelefono = telefono?.isNotEmpty == true;

    // El subtítulo es exclusivamente para el apodo
    final subtitle = hasApodo ? apodo : null;

    final status = AppStatus.active(item.estado);

    return AppCard(
      header: AppCardHeader(
        icon: const Icon(Icons.person_rounded),
        title: title,
        subtitle: subtitle,
        status: status,
        badge: AppStatusBadge(status: status),
      ),
      body: AppCardBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasTelefono) ...[
              AppCardInfoRow(
                icon: Icons.phone_rounded,
                label: 'Teléfono',
                value: telefono!,
              ),
              const SizedBox(height: 10),
            ],

            if (item.sedes.isNotEmpty) ...[
              AppCardTagSection(
                icon: Icons.business_rounded,
                label: 'Sedes',
                onTap: onManageSedes ?? () {},
                tags: item.sedes.map((clienteSede) {
                  final sedeNombre = clienteSede.sede?.nombre.trim();
                  final nombre = sedeNombre?.isNotEmpty == true
                      ? sedeNombre!
                      : 'Sede #${clienteSede.idSede}';

                  return AppTag(
                    label: '$nombre · ${clienteSede.tipoRelacion.label}',
                    size: AppTagSize.medium,
                  );
                }).toList(),
              ),
              if (item.puestos.isNotEmpty) const SizedBox(height: 10),
            ],

            if (item.puestos.isNotEmpty) ...[
              AppCardTagSection(
                icon: Icons.storefront_rounded,
                label: 'Puestos',
                onTap: onManagePuestos ?? () {},
                tags: item.puestos.map((clientePuesto) {
                  final puesto = clientePuesto.puesto;

                  final lugarNombre = puesto?.lugarOperativo?.nombre.trim();
                  final rawLugar = lugarNombre?.isNotEmpty == true
                      ? lugarNombre!
                      : 'Lugar #${puesto?.idLugar ?? clientePuesto.idPuesto}';

                  // Limitamos el texto a 20 caracteres máximo para que el tag no se desborde
                  final lugar = rawLugar.length > 20
                      ? '${rawLugar.substring(0, 20)}...'
                      : rawLugar;

                  final numeroPuesto = puesto?.numeroPuesto.trim();
                  final numero = numeroPuesto?.isNotEmpty == true
                      ? numeroPuesto!
                      : '#${clientePuesto.idPuesto}';

                  return AppTag(
                    label: '$lugar · Puesto $numero', // o Puesto
                    size: AppTagSize.medium,
                  );
                }).toList(),
              ),
            ],
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
}
