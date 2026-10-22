import 'package:flutter/material.dart';

/// Acción secundaria; el módulo conserva las reglas y confirmaciones.
class AppCardMenuAction {
  final IconData icon;
  final String label;
  final VoidCallback? onSelected;
  final bool enabled;
  final bool visible;

  const AppCardMenuAction({
    required this.icon,
    required this.label,
    required this.onSelected,
    this.enabled = true,
    this.visible = true,
  });
}

class AppCardMenu extends StatelessWidget {
  final List<AppCardMenuAction> actions;
  final String tooltip;

  const AppCardMenu({
    super.key,
    required this.actions,
    this.tooltip = 'Más acciones',
  });

  @override
  Widget build(BuildContext context) {
    final visible = actions.where((action) => action.visible).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return PopupMenuButton<AppCardMenuAction>(
      tooltip: tooltip,
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: (action) => action.onSelected?.call(),
      itemBuilder: (context) => visible.map((action) {
        final enabled = action.enabled && action.onSelected != null;
        final scheme = Theme.of(context).colorScheme;
        return PopupMenuItem<AppCardMenuAction>(
          value: action,
          enabled: enabled,
          child: Row(
            children: [
              Icon(
                action.icon,
                size: 20,
                color: enabled
                    ? scheme.onSurfaceVariant
                    : Theme.of(context).disabledColor,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(action.label)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
