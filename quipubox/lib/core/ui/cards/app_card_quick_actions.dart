import 'package:flutter/material.dart';

class AppCardQuickAction {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool showArrow;

  const AppCardQuickAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.showArrow = true,
  });
}

/// Implementación compartida del footer; los módulos usan AppCardActions.
class AppCardQuickActions extends StatelessWidget {
  final AppCardQuickAction? navigationAction;
  final AppCardQuickAction? secondaryNavigationAction;
  final AppCardQuickAction? operationalAction;

  const AppCardQuickActions({
    super.key,
    this.navigationAction,
    this.secondaryNavigationAction,
    this.operationalAction,
  });

  @override
  Widget build(BuildContext context) {
    final navigation = [
      if (navigationAction != null) navigationAction!,
      if (secondaryNavigationAction != null) secondaryNavigationAction!,
    ];
    final operation = operationalAction;
    if (navigation.isEmpty && operation == null) return const SizedBox.shrink();
    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.labelLarge),
    );
    Widget content(AppCardQuickAction action, {bool filled = false}) => Row(
      mainAxisAlignment: filled
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        Icon(action.icon, size: 18),
        const SizedBox(width: 6),
        Flexible(child: Text(action.label)),
        if (!filled && action.showArrow) ...[
          const SizedBox(width: 2),
          const Icon(Icons.chevron_right_rounded, size: 18),
        ],
      ],
    );
    final buttons = <Widget>[
      for (final action in navigation)
        TextButton(
          onPressed: action.onPressed,
          style: style,
          child: content(action),
        ),
      if (operation != null)
        FilledButton(
          onPressed: operation.onPressed,
          style: style,
          child: content(operation, filled: true),
        ),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.4,
              child: Divider(height: 1),
            ),
          ),
          const SizedBox(height: 4),
          LayoutBuilder(
            builder: (context, constraints) {
              final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
              if (buttons.length > 1 &&
                  constraints.maxWidth >= buttons.length * 148 * scale) {
                return Row(
                  children: [
                    for (var i = 0; i < buttons.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Expanded(child: buttons[i]),
                    ],
                  ],
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < buttons.length; i++) ...[
                    if (i > 0) const SizedBox(height: 4),
                    buttons[i],
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
