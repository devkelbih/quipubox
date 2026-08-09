import 'package:flutter/material.dart';
import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/core/ui/cards/app_card_actions.dart';
import 'package:quipubox/core/ui/cards/app_card_body.dart';
import 'package:quipubox/core/ui/cards/app_card_header.dart';
import 'package:quipubox/core/ui/cards/app_card_tag_section.dart';
import 'package:quipubox/core/ui/cards/app_status_badge.dart';
import 'package:quipubox/core/ui/status/app_status.dart';
import 'package:quipubox/core/ui/tags/app_tag.dart';

import '../../domain/entities/usuario.dart';

class UsuarioCard extends StatelessWidget {
  final Usuario item;
  final VoidCallback onEdit;
  final VoidCallback onChangeStatus;

  const UsuarioCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final title = item.nombreCompleto.isNotEmpty
        ? item.nombreCompleto
        : 'Usuario #${item.id}';
    final subtitle = item.sede.nombre.trim().isNotEmpty
        ? item.sede.nombre
        : 'Sede #${item.sede.id}';
    final avatarUrl = item.avatarUrl?.trim().isNotEmpty == true
        ? item.avatarUrl
        : null;
    return AppCard(
      header: AppCardHeader(
        icon: avatarUrl != null
            ? CircleAvatar(backgroundImage: NetworkImage(avatarUrl))
            : const Icon(Icons.person_rounded),
        title: title,
        subtitle: subtitle,
        badge: AppStatusBadge(status: AppStatus.active(item.estado)),
      ),
      body: AppCardBody(
        child: AppCardTagSection(
          icon: Icons.admin_panel_settings_rounded,
          label: 'Roles',
          tags: item.roles
              .map((role) => AppTag(label: role.nombre, size: AppTagSize.medium))
              .toList(),
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
