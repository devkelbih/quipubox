import 'package:flutter/material.dart';

class AppCardTagSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Widget> tags;
  final VoidCallback? onTap;

  const AppCardTagSection({
    super.key,
    required this.icon,
    required this.label,
    required this.tags,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final isClickable = onTap != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // <-- Cambiado a center para alinear todo verticalmente
            children: [
              // Ícono izquierdo
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 18,
                  color: scheme.primary,
                ),
              ),

              const SizedBox(width: 12),

              // Contenido central (Label y Tags)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Evita que la columna ocupe más espacio del necesario
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: tags,
                    ),
                  ],
                ),
              ),

              // Flecha derecha
              if (isClickable) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 30,
                  color: scheme.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}