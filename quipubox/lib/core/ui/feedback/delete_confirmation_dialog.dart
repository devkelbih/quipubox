import 'package:flutter/material.dart';

import 'app_toast.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
  });

  static Future<bool> showAndAction({
    required BuildContext context,
    required String title,
    required String message,
    required Future<bool> Function() onConfirm,
    required String? Function() getErrorMessage,
    required String successMessage,
    required String fallbackError,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => DeleteConfirmationDialog(title: title, message: message),
    );
    if (confirmed != true || !context.mounted) return false;
    final succeeded = await onConfirm();
    if (!context.mounted) return succeeded;
    AppToast.show(
      succeeded ? successMessage : getErrorMessage() ?? fallbackError,
      type: succeeded ? ToastType.success : ToastType.error,
    );
    return succeeded;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      icon: CircleAvatar(
        radius: 30,
        backgroundColor: colors.errorContainer,
        child: Icon(
          Icons.delete_outline,
          color: colors.onErrorContainer,
          size: 30,
        ),
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: colors.onSurfaceVariant, height: 1.35),
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
                style: FilledButton.styleFrom(
                  backgroundColor: colors.error,
                  foregroundColor: colors.onErrorContainer,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Eliminar'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
