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
                      final updatedRoleIds = Set<int>.from(selectedRoleIds);

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
                    IconButton(
                      icon: const Icon(
                        Icons.info_outline,
                        size: 20,
                      ),
                      tooltip: 'Ver descripción',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      onPressed: () {
                        _showRoleDescription(
                          context,
                          role,
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

  void _showRoleDescription(
    BuildContext context,
    Role role,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.info_outline),
              const SizedBox(width: 8),
              Expanded(
                child: Text(role.nombre),
              ),
            ],
          ),
          content: Text(
            role.descripcion?.trim().isNotEmpty == true
                ? role.descripcion!.trim()
                : 'Este rol no tiene una descripción disponible.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}