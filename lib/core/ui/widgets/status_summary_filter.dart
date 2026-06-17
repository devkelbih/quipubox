import 'package:flutter/material.dart';

enum StatusSummaryValue { all, active, inactive }

class StatusSummaryFilter extends StatelessWidget {
  final int total;
  final int active;
  final int inactive;
  final StatusSummaryValue selected;
  final ValueChanged<StatusSummaryValue> onChanged;

  const StatusSummaryFilter({
    super.key,
    required this.total,
    required this.active,
    required this.inactive,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            _StatusSummaryItem(
              value: total.toString(),
              label: 'Total',
              icon: Icons.apps_rounded,
              selected: selected == StatusSummaryValue.all,
              onTap: () => onChanged(StatusSummaryValue.all),
            ),
            _StatusSummaryItem(
              value: active.toString(),
              label: 'Activas',
              icon: Icons.check_circle_rounded,
              selected: selected == StatusSummaryValue.active,
              onTap: () => onChanged(StatusSummaryValue.active),
            ),
            _StatusSummaryItem(
              value: inactive.toString(),
              label: 'Inactivas',
              icon: Icons.block_rounded,
              selected: selected == StatusSummaryValue.inactive,
              onTap: () => onChanged(StatusSummaryValue.inactive),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusSummaryItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _StatusSummaryItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
          decoration: BoxDecoration(
            color: selected ? colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 19,
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  height: 1,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: selected ? colorScheme.primary : colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  height: 1,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}