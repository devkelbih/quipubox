import 'package:flutter/material.dart';

import 'package:quipubox/core/ui/tags/app_tag.dart';
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        if (roles.isEmpty)
          const Text(
            'No hay roles disponibles.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: roles.map((role) {
              final isSelected = selectedRoleIds.contains(role.id);

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      final updatedRoleIds = Set<int>.from(selectedRoleIds);

                      if (isSelected) {
                        updatedRoleIds.remove(role.id);
                      } else {
                        updatedRoleIds.add(role.id);
                      }

                      onChanged(updatedRoleIds);
                    },
                    child: AppTag(
                      label: role.nombre,
                      size: AppTagSize.large,
                      selected: isSelected,
                    ),
                  ),

                  if (role.descripcion != null &&
                      role.descripcion!.trim().isNotEmpty)
                    const SizedBox(width: 4),
                  Builder(
                    builder: (iconContext) {
                      return SizedBox(
                        width: 24,
                        height: 24,
                        child: IconButton(
                          icon: const Icon(Icons.info_outline, size: 17),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            _showRolePopup(iconContext, role);
                          },
                        ),
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
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }

  void _showRolePopup(BuildContext context, Role role) {
    final RenderBox button = context.findRenderObject() as RenderBox;

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        PopupMenuItem<void>(
          enabled: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
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
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
