import 'package:flutter/material.dart';

import 'package:quipubox/features/roles/domain/entities/role.dart';

class UsuarioRolesForm extends StatelessWidget {
  final List<Role> roles;
  final Set<int> selectedRoleIds;
  final ValueChanged<Set<int>> onChanged;
  final bool hasError;

  const UsuarioRolesForm({
    super.key,
    required this.roles,
    required this.selectedRoleIds,
    required this.onChanged,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Roles del Usuario',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        if (roles.isEmpty)
          const Text(
            'No hay roles disponibles.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: roles.map((role) {
              final isSelected = selectedRoleIds.contains(role.id);

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilterChip(
                    label: Text(role.nombre),
                    selected: isSelected,
                    onSelected: (selected) {
                      final updatedRoleIds =
                          Set<int>.from(selectedRoleIds);

                      if (selected) {
                        updatedRoleIds.add(role.id);
                      } else {
                        updatedRoleIds.remove(role.id);
                      }

                      onChanged(updatedRoleIds);
                    },
                  ),

                  if (role.descripcion != null &&
                      role.descripcion!.trim().isNotEmpty)
                    Builder(
                      builder: (iconContext) {
                        return IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            size: 18,
                          ),
                          tooltip: 'Ver información',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          onPressed: () {
                            _showRolePopup(
                              iconContext,
                              role,
                            );
                          },
                        );
                      },
                    ),
                ],
              );
            }).toList(),
          ),

        if (hasError) ...[
          const SizedBox(height: 8),
          const Text(
            'Selecciona al menos un rol.',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  void _showRolePopup(
    BuildContext context,
    Role role,
  ) {
    final RenderBox button =
        context.findRenderObject() as RenderBox;

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    final RelativeRect positionRect = RelativeRect.fromRect(
      Rect.fromLTWH(
        position.dx,
        position.dy,
        button.size.width,
        button.size.height,
      ),
      Offset.zero & overlay.size,
    );

    showMenu<void>(
      context: context,
      position: positionRect,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      items: [
        PopupMenuItem<void>(
          enabled: true,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 260,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.badge_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        role.nombre,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  role.descripcion!.trim(),
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}