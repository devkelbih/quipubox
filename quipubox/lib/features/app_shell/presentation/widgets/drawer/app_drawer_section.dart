import 'package:flutter/material.dart';
import 'drawer_metrics.dart';

/// ===============================================================
/// AppDrawerSection
/// ---------------------------------------------------------------
/// Títulos de sección para organizar el drawer.
/// ===============================================================
class AppDrawerSection extends StatelessWidget {
  final String title;
  final EdgeInsets? padding;

  const AppDrawerSection(
    this.title, {
    super.key,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 14,
          ),
      child: Row(
        children: [
          // Línea decorativa
          Container(
            width: 18,
            height: 3,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 8),
          // Título
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: DrawerMetrics.sectionSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.9,
            ),
          ),
        ],
      ),
    );
  }
}