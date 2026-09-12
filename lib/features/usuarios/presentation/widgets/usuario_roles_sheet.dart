import 'package:flutter/material.dart';

import 'package:quipubox/features/roles/domain/entities/role.dart';
import 'package:quipubox/features/usuarios/domain/entities/usuario.dart';

class UsuarioRolesSheet extends StatefulWidget {
  final Usuario usuario;
  final List<Role> roles;
  final ScrollController controller;

  final int? processingRoleId;

  final ValueChanged<Role>? onAddRole;
  final ValueChanged<Role>? onRemoveRole;

  const UsuarioRolesSheet({
    super.key,
    required this.usuario,
    required this.roles,
    required this.controller,
    this.processingRoleId,
    this.onAddRole,
    this.onRemoveRole,
  });

  @override
  State<UsuarioRolesSheet> createState() => _UsuarioRolesSheetState();
}

class _UsuarioRolesSheetState extends State<UsuarioRolesSheet> {
  int? _expandedRoleId;

  Set<int> get _assignedRoleIds {
    return widget.usuario.roles.map((role) => role.id).toSet();
  }

  List<Role> get _assignedRoles {
    final assignedRoleIds = _assignedRoleIds;

    return widget.roles
        .where((role) => assignedRoleIds.contains(role.id))
        .toList();
  }

  List<Role> get _otherRoles {
    final assignedRoleIds = _assignedRoleIds;

    return widget.roles
        .where((role) => !assignedRoleIds.contains(role.id))
        .toList();
  }

  bool _isProcessing(Role role) {
    return widget.processingRoleId == role.id;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      controller: widget.controller,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        if (widget.roles.isEmpty)
          Text(
            'No hay roles disponibles.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          )
        else ...[
          if (_assignedRoles.isNotEmpty) ...[
            _buildSectionTitle(context, 'Roles asignados'),
            const SizedBox(height: 8),
            _buildRolesGroup(context, _assignedRoles, isAssigned: true),
          ],
          if (_otherRoles.isNotEmpty) ...[
            if (_assignedRoles.isNotEmpty) const SizedBox(height: 20),
            _buildSectionTitle(context, 'Otros roles'),
            const SizedBox(height: 8),
            _buildRolesGroup(context, _otherRoles, isAssigned: false),
          ],
        ],
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildRolesGroup(
    BuildContext context,
    List<Role> roles, {
    required bool isAssigned,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int index = 0; index < roles.length; index++) ...[
            _buildRole(context, roles[index], isAssigned: isAssigned),
            if (index < roles.length - 1)
              Divider(height: 1, color: colorScheme.outlineVariant),
          ],
        ],
      ),
    );
  }

  Widget _buildRole(
    BuildContext context,
    Role role, {
    required bool isAssigned,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final isExpanded = _expandedRoleId == role.id;
    final isProcessing = _isProcessing(role);
    final hasProcessing = widget.processingRoleId != null;

    final hasDescription =
        role.descripcion != null && role.descripcion!.trim().isNotEmpty;

    final isLastAssignedRole = isAssigned && _assignedRoleIds.length == 1;

    final canRemove =
        isAssigned &&
        !isLastAssignedRole &&
        widget.onRemoveRole != null &&
        !hasProcessing;

    final canAdd = !isAssigned && widget.onAddRole != null && !hasProcessing;

    final backgroundColor = isAssigned
        ? colorScheme.primaryContainer.withValues(alpha: 0.35)
        : colorScheme.surface;

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: hasDescription
            ? () {
                setState(() {
                  _expandedRoleId = isExpanded ? null : role.id;
                });
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 11, 10, 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isAssigned ? Icons.badge_rounded : Icons.badge_outlined,
                    size: 20,
                    color: isAssigned
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      role.nombre,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isAssigned
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  _buildRoleAction(
                    context,
                    role,
                    isAssigned: isAssigned,
                    enabled: isAssigned ? canRemove : canAdd,
                    isLastAssignedRole: isLastAssignedRole,
                    isProcessing: isProcessing,
                  ),
                ],
              ),
              if (isExpanded && hasDescription) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 34),
                  child: Text(
                    role.descripcion!.trim(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleAction(
    BuildContext context,
    Role role, {
    required bool isAssigned,
    required bool enabled,
    required bool isLastAssignedRole,
    required bool isProcessing,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isProcessing) {
      return const SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final tooltip = isAssigned
        ? isLastAssignedRole
              ? 'El usuario debe tener al menos un rol'
              : 'Quitar rol'
        : 'Agregar rol';

    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        onPressed: enabled
            ? () {
                if (isAssigned) {
                  widget.onRemoveRole?.call(role);
                } else {
                  widget.onAddRole?.call(role);
                }
              }
            : null,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        visualDensity: VisualDensity.compact,
        tooltip: tooltip,
        icon: Icon(
          isAssigned
              ? Icons.remove_circle_outline_rounded
              : Icons.add_circle_outline_rounded,
          size: 21,
          color: enabled
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
