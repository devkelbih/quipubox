import 'package:flutter/material.dart';

class AppCardTagSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Widget> tags;

  const AppCardTagSection({
    super.key,
    required this.icon,
    required this.label,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
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
          child: Icon(icon, size: 18, color: scheme.primary),
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

              Wrap(spacing: 6, runSpacing: 6, children: tags),
            ],
          ),
        ),
      ],
    );
  }
}
