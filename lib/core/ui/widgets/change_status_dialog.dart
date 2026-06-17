import 'package:flutter/material.dart';

class ChangeStatusDialog extends StatelessWidget {
  final bool newStatus;
  final String title;
  final String message;
  final String confirmText;

  const ChangeStatusDialog({
    super.key,
    required this.newStatus,
    required this.title,
    required this.message,
    required this.confirmText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final icon = newStatus
        ? Icons.check_circle_rounded
        : Icons.block_rounded;

    final backgroundColor = newStatus
        ? colorScheme.primaryContainer
        : colorScheme.errorContainer;

    final iconColor = newStatus
        ? colorScheme.onPrimaryContainer
        : colorScheme.onErrorContainer;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      icon: CircleAvatar(
        radius: 30,
        backgroundColor: backgroundColor,
        child: Icon(icon, color: iconColor, size: 30),
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
        ),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          height: 1.35,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(confirmText),
              ),
            ),
          ],
        ),
      ],
    );
  }
}