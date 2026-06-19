import 'package:flutter/material.dart';

import '../../domain/entities/tipos_jaba.dart';
import '../../domain/enums/tipo_material_jaba.dart';

class TipoJabaCard extends StatelessWidget {
  final TipoJaba item;
  final VoidCallback onEdit;
  final VoidCallback onChangeStatus;

  const TipoJabaCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                _TipoJabaIcon(material: item.tipoMaterial, active: item.estado),
                const SizedBox(width: 12),
                Expanded(child: _Header(item: item)),
                _StatusBadge(active: item.estado),
              ],
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.45,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _InfoLine(
                    icon: _materialIcon(item.tipoMaterial),
                    label: 'Material',
                    value: item.tipoMaterial.label,
                  ),
                  if (_hasText(item.descripcion)) ...[
                    const SizedBox(height: 8),
                    _InfoLine(
                      icon: Icons.description_rounded,
                      label: 'Descripción',
                      value: item.descripcion!,
                    ),
                  ],
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

  static bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  static IconData _materialIcon(TipoMaterialJaba material) {
    switch (material) {
      case TipoMaterialJaba.madera:
        return Icons.forest_rounded;
      case TipoMaterialJaba.plastico:
        return Icons.inventory_2_rounded;
    }
  }
}

class _TipoJabaIcon extends StatelessWidget {
  final TipoMaterialJaba material;
  final bool active;

  const _TipoJabaIcon({required this.material, required this.active});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = active ? colorScheme.primary : colorScheme.error;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(TipoJabaCard._materialIcon(material), color: color),
    );
  }
}

class _Header extends StatelessWidget {
  final TipoJaba item;

  const _Header({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.nombre.trim().isEmpty
              ? 'Tipo de jaba #${item.id ?? '-'}'
              : item.nombre,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 3),
        Text(
          item.tipoMaterial.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
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
          ),
        ),
      ],
    );
  }
}
