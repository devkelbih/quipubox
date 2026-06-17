import 'dart:async';

import 'package:flutter/material.dart';

import '../navigation/navigation_keys.dart';

enum ToastType { success, error, warning, info }

class AppToast {
  const AppToast._();

  static OverlayEntry? _activeEntry;
  static Timer? _timer;

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

class _ToastOverlay extends StatefulWidget {
  final String message;
  final ToastType type;

  const _ToastOverlay({
    required this.message,
    required this.type,
  });

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, -0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top + 14;
    final colorScheme = Theme.of(context).colorScheme;
    final style = _ToastStyle.fromType(widget.type, colorScheme);

    return Positioned(
      top: top,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          bottom: false,
          child: Center(
            child: SlideTransition(
              position: _slide,
              child: FadeTransition(
                opacity: _opacity,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.75,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Container(
                            width: 5,
                            decoration: BoxDecoration(
                              color: style.color,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(18),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: style.color.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      style.icon,
                                      size: 20,
                                      color: style.color,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      widget.message,
                                      style: TextStyle(
                                        color: colorScheme.onSurface,
                                        fontWeight: FontWeight.w800,
                                        decoration: TextDecoration.none,
                                        fontSize: 14,
                                        height: 1.25,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    tooltip: 'Cerrar',
                                    onPressed: AppToast.dismiss,
                                    icon: Icon(
                                      Icons.close_rounded,
                                      size: 20,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
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
        ),
      ),
    );
  }
}

class _ToastStyle {
  final Color color;
  final IconData icon;

  const _ToastStyle({
    required this.color,
    required this.icon,
  });

  factory _ToastStyle.fromType(ToastType type, ColorScheme colorScheme) {
    return switch (type) {
      ToastType.success => _ToastStyle(
          color: const Color(0xFF16A34A),
          icon: Icons.check_circle_rounded,
        ),
      ToastType.error => _ToastStyle(
          color: colorScheme.error,
          icon: Icons.error_rounded,
        ),
      ToastType.warning => _ToastStyle(
          color: const Color(0xFFF59E0B),
          icon: Icons.warning_amber_rounded,
        ),
      ToastType.info => _ToastStyle(
          color: colorScheme.primary,
          icon: Icons.info_rounded,
        ),
    };
  }
}