import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),

            if (onAction != null) ...[
              const SizedBox(height: 20),

              FilledButton(
                onPressed: onAction,
                child: Text(actionLabel ?? 'Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
