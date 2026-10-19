import 'package:flutter/material.dart';

enum StatusSummaryValue { all, active, inactive }

class AppStatusTabBar extends StatelessWidget implements PreferredSizeWidget {
  final int total;
  final int active;
  final int inactive;
  final StatusSummaryValue? selected;
  final ValueChanged<StatusSummaryValue>? onChanged;
  final List<StatusFilterTab>? statusTabs;
  final String? selectedStatus;
  final ValueChanged<String>? onStatusChanged;

  const AppStatusTabBar({
    super.key,
    required this.total,
    required this.active,
    required this.inactive,
    required this.selected,
    required this.onChanged,
  }) : statusTabs = null,
       selectedStatus = null,
       onStatusChanged = null;

  const AppStatusTabBar.forStatuses({
    super.key,
    required List<StatusFilterTab> tabs,
    required String selected,
    required ValueChanged<String> onChanged,
  }) : total = 0,
       active = 0,
       inactive = 0,
       selected = null,
       onChanged = null,
       statusTabs = tabs,
       selectedStatus = selected,
       onStatusChanged = onChanged;

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tabs = statusTabs;

    return Material(
      color: colorScheme.surfaceContainerLowest,
      elevation: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: .45),
            ),
          ),
        ),
        child: tabs == null
            ? Row(
                children: [
                  Expanded(
                    child: _AppStatusTab(
                      label: 'Todas',
                      count: total,
                      selected: selected == StatusSummaryValue.all,
                      onTap: () => onChanged!(StatusSummaryValue.all),
                    ),
                  ),
                  Expanded(
                    child: _AppStatusTab(
                      label: 'Activas',
                      count: active,
                      selected: selected == StatusSummaryValue.active,
                      onTap: () => onChanged!(StatusSummaryValue.active),
                    ),
                  ),
                  Expanded(
                    child: _AppStatusTab(
                      label: 'Inactivas',
                      count: inactive,
                      selected: selected == StatusSummaryValue.inactive,
                      onTap: () => onChanged!(StatusSummaryValue.inactive),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  for (final tab in tabs)
                    Expanded(
                      child: _AppStatusTab(
                        label: tab.label,
                        count: tab.count,
                        selected: selectedStatus == tab.value,
                        dense: true,
                        onTap: () => onStatusChanged!(tab.value),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class StatusFilterTab {
  final String value;
  final String label;
  final int count;

  const StatusFilterTab({
    required this.value,
    required this.label,
    required this.count,
  });
}

class _AppStatusTab extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final bool dense;
  final VoidCallback onTap;

  const _AppStatusTab({
    required this.label,
    required this.count,
    required this.selected,
    this.dense = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final color = selected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 52,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    style: TextStyle(
                      fontSize: dense ? 11 : 14,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      color: color,
                    ),
                    child: Text(
                      '$label ($count)',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                width: selected ? 36 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
