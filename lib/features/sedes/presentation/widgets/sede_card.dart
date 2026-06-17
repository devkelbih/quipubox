import 'package:flutter/material.dart';

import '../../domain/entities/sede.dart';
import '../../domain/enums/tipo_sede.dart';

class SedeCard extends StatelessWidget {
  final Sede item;
  final VoidCallback onEdit;
  final VoidCallback onChangeStatus;

  const SedeCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final location = _locationText(item);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                _TypeIcon(item: item),
                const SizedBox(width: 12),
                Expanded(child: _Header(item: item)),
                _StatusBadge(active: item.estado),
              ],
            ),
            if (location != null || _hasText(item.direccion)) ...[
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
                    if (location != null)
                      _InfoLine(
                        icon: Icons.map_rounded,
                        label: 'Ubicación',
                        value: location,
                      ),
                    if (_hasText(item.direccion)) ...[
                      const SizedBox(height: 8),
                      _InfoLine(
                        icon: Icons.place_rounded,
                        label: 'Dirección',
                        value: item.direccion!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
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

  static String? _locationText(Sede item) {
    final ciudad = item.ciudad?.trim();
    final departamento = item.departamento?.trim();

    if (_hasText(ciudad) && _hasText(departamento)) {
      if (ciudad!.toLowerCase() == departamento!.toLowerCase()) {
        return ciudad;
      }
      return '$ciudad, $departamento';
    }

    if (_hasText(ciudad)) return ciudad;
    if (_hasText(departamento)) return departamento;

    return null;
  }

  static IconData _iconByType(TipoSede value) {
    switch (value) {
      case TipoSede.origen:
        return Icons.upload_rounded;
      case TipoSede.destino:
        return Icons.download_rounded;
      case TipoSede.ambos:
        return Icons.sync_alt_rounded;
    }
  }

  static bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

class _TypeIcon extends StatelessWidget {
  final Sede item;

  const _TypeIcon({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: item.estado
            ? colorScheme.primary.withValues(alpha: 0.12)
            : colorScheme.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        SedeCard._iconByType(item.tipoSede),
        color: item.estado ? colorScheme.primary : colorScheme.error,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Sede item;

  const _Header({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.nombre.isEmpty ? 'Sede #${item.id}' : item.nombre,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          item.tipoSede.label,
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