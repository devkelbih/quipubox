import 'package:flutter/material.dart';
import 'package:quipubox/core/common/string_extensions.dart';

import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_menu.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_info_row.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/status/app_status.dart';

import '../../domain/entities/usuario.dart';

class UsuarioCard extends StatelessWidget {
  final Usuario item;
  final VoidCallback onEdit;
  final VoidCallback onChangeStatus;
  final VoidCallback onManageRoles;

  const UsuarioCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onChangeStatus,
    required this.onManageRoles,
  });

  @override
  Widget build(BuildContext context) {
    final nombreCompleto = item.nombreCompleto;
    final title = nombreCompleto.hasText
        ? nombreCompleto
        : 'Usuario #${item.id}';

    final sedeNombre = item.sede?.nombre.value;
    final subtitle = sedeNombre ?? 'Sede #${item.idSede}';

    final avatarUrl = item.avatarUrl.value;
    final status = AppStatus.active(item.estado);
    return AppCard(
      header: AppCardHeader(
        icon: avatarUrl != null
            ? CircleAvatar(backgroundImage: NetworkImage(avatarUrl))
            : const Icon(Icons.person_rounded),
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
              icon: Icons.admin_panel_settings_rounded,
              label: 'Gestionar roles',
              onSelected: onManageRoles,
            ),
          ],
        ),
      ),
      body: AppCardBody(
        child: AppCardInfoRow(
          icon: Icons.admin_panel_settings_rounded,
          label: 'Roles',
          value: item.roles.isEmpty
              ? 'Sin roles asignados'
              : item.roles.map((role) => role.nombre).join(' · '),
        ),
      ),
    );
  }
}
