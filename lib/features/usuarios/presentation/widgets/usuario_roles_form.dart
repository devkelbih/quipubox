import 'package:flutter/material.dart';

import 'package:quipubox/core/ui/sheets/app_bottom_sheet.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Roles del usuario',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 8),

        Text(
          'Los roles determinan las funciones que el usuario puede '
          'realizar dentro de la aplicación. Puedes asignar uno o '
          'varios roles según sus responsabilidades.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 24),

        if (roles.isEmpty)
          Text(
            'No hay roles disponibles.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (int index = 0; index < roles.length; index++) ...[
                  _buildRoleTile(context, roles[index]),

                  if (index < roles.length - 1)
                    Divider(height: 1, color: colorScheme.outlineVariant),
                ],
              ],
            ),
          ),

        if (hasError) ...[
          const SizedBox(height: 8),
          Text(
            'Selecciona al menos un rol.',
            style: TextStyle(color: colorScheme.error, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildRoleTile(BuildContext context, Role role) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = selectedRoleIds.contains(role.id);

    return Material(
      color: isSelected
          ? colorScheme.primaryContainer.withValues(alpha: 0.35)
          : colorScheme.surface,
      child: InkWell(
        onTap: () => _toggleRole(role),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildSelectionIndicator(context, isSelected),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  role.nombre,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),

              IconButton(
                onPressed: () => _showRoleDescription(context, role),
                icon: const Icon(Icons.info_outline_rounded, size: 20),
                tooltip: 'Ver descripción',
                color: colorScheme.onSurfaceVariant,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(BuildContext context, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? colorScheme.primary : colorScheme.outline,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: isSelected
          ? Icon(Icons.check_rounded, size: 16, color: colorScheme.onPrimary)
          : null,
    );
  }

  void _toggleRole(Role role) {
    final updatedRoleIds = Set<int>.from(selectedRoleIds);

    if (updatedRoleIds.contains(role.id)) {
      updatedRoleIds.remove(role.id);
    } else {
      updatedRoleIds.add(role.id);
    }

    onChanged(updatedRoleIds);
  }

  Future<void> _showRoleDescription(BuildContext context, Role role) async {
    final description = role.descripcion?.trim();

    if (description == null || description.isEmpty) {
      return;
    }

    await AppBottomSheet.show<void>(
      context: context,
      title: role.nombre,
      initialChildSize: 0.3,
      minChildSize: 0.25,
      maxChildSize: 0.4,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.badge_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
