import 'package:flutter/material.dart';

/// Widget reutilizable que muestra una sección con:
/// - Un ícono dentro de un contenedor con fondo redondeado (a la izquierda).
/// - Una etiqueta de texto (label) arriba.
/// - Una lista de "tags" que se acomodan en varias líneas.
/// - Opcionalmente, permite interacción mediante [onTap].
///
/// Ejemplo no interactivo:
/// [ Icon ]   Roles
///            [tag] [tag] [tag]
///            [tag] [tag]
///
/// Ejemplo interactivo:
/// [ Icon ]   Roles                                      >
///            [tag] [tag] [tag]
///            [tag] [tag]
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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

              if (isClickable)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 30,
                      color: scheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}