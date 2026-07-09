import 'package:flutter/material.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    final name = item.nombreCompleto.isNotEmpty
        ? item.nombreCompleto
        : 'Usuario #${item.id}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                _UserAvatar(item: item),
                const SizedBox(width: 12),
                Expanded(
                  child: _Header(
                    name: name,
                    email: item.email,
                  ),
                ),
                _StatusBadge(active: item.estado),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  if (_hasText(item.telefono))
                    _InfoLine(
                      icon: Icons.phone_rounded,
                      label: 'Teléfono',
                      value: item.telefono!,
                    ),
                  if (_hasText(item.telefono)) const SizedBox(height: 8),
                  _InfoLine(
                    icon: Icons.business_rounded,
                    label: 'Empresa',
                    value: _empresaText(item),
                  ),
                  const SizedBox(height: 8),
                  _InfoLine(
                    icon: Icons.store_mall_directory_rounded,
                    label: 'Sede',
                    value: _sedeText(item),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...item.roles.map(
                    (role) => _SoftChip(
                      icon: Icons.admin_panel_settings_rounded,
                      label: _formatRoleName(role.nombre),
                    ),
                  ),
                  if (item.roles.isEmpty)
                    const _SoftChip(
                      icon: Icons.warning_amber_rounded,
                      label: 'Sin rol',
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: const Text('Editar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: onChangeStatus,
                    icon: Icon(
                      item.estado
                          ? Icons.block_rounded
                          : Icons.check_circle_rounded,
                      size: 18,
                    ),
                    label: Text(item.estado ? 'Desactivar' : 'Activar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _empresaText(Usuario item) {
    if (_hasText(item.empresa.nombreComercial)) {
      return item.empresa.nombreComercial;
    }

    return item.empresa.razonSocial;
  }

  static String _sedeText(Usuario item) {
    final ciudad = item.sede.ciudad?.trim();

    if (_hasText(ciudad)) {
      return '${item.sede.nombre} · $ciudad';
    }

    return item.sede.nombre;
  }

  static String _formatRoleName(String value) {
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .where((e) => e.trim().isNotEmpty)
        .map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase())
        .join(' ');
  }

  static bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

class _UserAvatar extends StatelessWidget {
  final Usuario item;

  const _UserAvatar({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final avatarUrl = item.avatarUrl;

    if (avatarUrl != null && avatarUrl.trim().isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(avatarUrl),
        backgroundColor: colorScheme.surfaceContainerHighest,
      );
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: item.estado
            ? colorScheme.primary.withValues(alpha: 0.12)
            : colorScheme.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          _initials(item),
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: item.estado ? colorScheme.primary : colorScheme.error,
          ),
        ),
      ),
    );
  }

  static String _initials(Usuario item) {
    final first = item.nombres.trim().isNotEmpty
        ? item.nombres.trim()[0]
        : '';

    final last = item.apellidos != null && item.apellidos!.trim().isNotEmpty
        ? item.apellidos!.trim()[0]
        : '';

    final result = '$first$last'.toUpperCase();

    return result.isEmpty ? 'U' : result;
  }
}

class _Header extends StatelessWidget {
  final String name;
  final String email;

  const _Header({
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          email,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool active;

  const _StatusBadge({required this.active});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = active ? colorScheme.primary : colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        active ? 'Activo' : 'Inactivo',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _SoftChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SoftChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}