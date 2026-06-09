import 'package:flutter/material.dart';

enum ToastType { success, error, warning, info }

class AppToast {
  const AppToast._();

  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
  }) {
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(_icon(type), color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: _color(type),
        ),
      );
  }

  static IconData _icon(ToastType type) {
    return switch (type) {
      ToastType.success => Icons.check_circle_outline,
      ToastType.error => Icons.error_outline,
      ToastType.warning => Icons.warning_amber_outlined,
      ToastType.info => Icons.info_outline,
    };
  }

  static Color _color(ToastType type) {
    return switch (type) {
      ToastType.success => const Color(0xFF15803D),
      ToastType.error => const Color(0xFFB91C1C),
      ToastType.warning => const Color(0xFFB45309),
      ToastType.info => const Color(0xFF1E40AF),
    };
  }
}
