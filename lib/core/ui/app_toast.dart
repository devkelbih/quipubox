import 'dart:async';

import 'package:flutter/material.dart';

import '../navigation/navigation_keys.dart';

enum ToastType { success, error, warning, info }

class AppToast {
  const AppToast._();

  static OverlayEntry? _activeEntry;
  static Timer? _timer;

  /// Muestra mensajes usando el Overlay del navegador raíz.
  /// Esto permite que el mensaje quede por encima de diálogos, bottom sheets y rutas.
  static void show(String message, {ToastType type = ToastType.info}) {
    final overlay = NavigationKeys.rootNavigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _timer?.cancel();
    _activeEntry?.remove();

    _activeEntry = OverlayEntry(
      builder: (context) => _ToastOverlay(message: message, type: type),
    );

    overlay.insert(_activeEntry!);
    _timer = Timer(const Duration(seconds: 4), dismiss);
  }

  static void dismiss() {
    _timer?.cancel();
    _timer = null;
    _activeEntry?.remove();
    _activeEntry = null;
  }
}

class _ToastOverlay extends StatelessWidget {
  final String message;
  final ToastType type;

  const _ToastOverlay({required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top + 14;
    final color = switch (type) {
      ToastType.success => const Color(0xFF16803C),
      ToastType.error => const Color(0xFFC62828),
      ToastType.warning => const Color(0xFFB26A00),
      ToastType.info => const Color(0xFF1E5AA8),
    };
    final icon = switch (type) {
      ToastType.success => Icons.check_circle_outline_rounded,
      ToastType.error => Icons.error_outline_rounded,
      ToastType.warning => Icons.warning_amber_rounded,
      ToastType.info => Icons.info_outline_rounded,
    };

    return Positioned(
      top: top,
      left: 16,
      right: 16,
      child: IgnorePointer(
        ignoring: true,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 24,
                      offset: Offset(0, 10),
                      color: Color(0x33000000),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: Colors.white),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.none,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
