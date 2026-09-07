import 'package:flutter/material.dart';
import 'package:quipubox/core/ui/feedback/app_toast.dart';

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

  /// Helper estático para mostrar la alerta, ejecutar la acción y notificar el resultado.
  static Future<void> showAndAction({
    required BuildContext context,
    required bool currentStatus,
    required String article, // Obligatorio: 'el' o 'la'
    required String entityName, // Ej: 'Sede', 'Fruta', 'Camión'
    required String itemName, // Ej: item.nombre, item.placa
    required Future<bool> Function(bool newStatus) onConfirm,
    required String? Function()
    getErrorMessage, // Obligatorio: Callback para leer el error del ViewModel tras la ejecución
  }) async {
    final newStatus = !currentStatus;
    final actionText = newStatus ? 'Activar' : 'Desactivar';
    final artLower = article.toLowerCase();
    final isFemale = artLower == 'la';

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ChangeStatusDialog(
        newStatus: newStatus,
        title: '$actionText ${entityName.toLowerCase()}',
        message: newStatus
            ? '$article ${entityName.toLowerCase()} "$itemName" volverá a estar disponible.'
            : '$article ${entityName.toLowerCase()} "$itemName" dejará de estar disponible.',
        confirmText: actionText,
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final ok = await onConfirm(newStatus);

    if (!context.mounted) return;

    final genderSuffix = isFemale ? 'a' : 'o';
    final successMessage = newStatus
        ? '$entityName activad$genderSuffix correctamente.'
        : '$entityName desactivad$genderSuffix correctamente.';

    final fallbackError = newStatus
        ? 'No se pudo activar $artLower ${entityName.toLowerCase()}.'
        : 'No se pudo desactivar $artLower ${entityName.toLowerCase()}.';

    // Se obtiene el error actualizado del ViewModel tras terminar la petición
    final errorMessage = getErrorMessage();

    AppToast.show(
      ok ? successMessage : (errorMessage ?? fallbackError),
      type: ok ? ToastType.success : ToastType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final icon = newStatus ? Icons.check_circle_rounded : Icons.block_rounded;

    final backgroundColor = newStatus
        ? colorScheme.primaryContainer
        : colorScheme.errorContainer;

    final iconColor = newStatus
        ? colorScheme.onPrimaryContainer
        : colorScheme.onErrorContainer;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      icon: CircleAvatar(
        radius: 30,
        backgroundColor: backgroundColor,
        child: Icon(icon, color: iconColor, size: 30),
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: colorScheme.onSurfaceVariant, height: 1.35),
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
