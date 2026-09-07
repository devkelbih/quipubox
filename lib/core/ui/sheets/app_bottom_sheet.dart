import 'package:flutter/material.dart';

class AppBottomSheet extends StatelessWidget {
  final String title;

  /// Usamos un builder que provee el [ScrollController] para que
  /// widgets deslizables (ListView, SingleChildScrollView) se sincronicen
  /// con el arrastre del sheet.
  final Widget Function(BuildContext context, ScrollController controller) builder;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final Widget? trailing;

  const AppBottomSheet({
    super.key,
    required this.title,
    required this.builder,
    this.initialChildSize = 0.4, // 40% por defecto
    this.minChildSize = 0.2, // 20% mínimo
    this.maxChildSize = 0.7, // 70% máximo
    this.trailing,
  });

  /// Función estática helper para invocar el Sheet sin repetir código de configuración.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget Function(BuildContext context, ScrollController controller) builder,
    double initialChildSize = 0.5,
    double minChildSize = 0.2,
    double maxChildSize = 0.7,
    Widget? trailing,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: false, // <-- Cambiado a false para evitar marcos transparentes feos
      builder: (_) => AppBottomSheet(
        title: title,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        trailing: trailing,
        builder: builder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (context, scrollController) {
        return Material(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Handle de arrastre centrado
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Encabezado estandarizado
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    if (trailing != null) trailing!,
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Cuerpo dinámico pasando el controlador + resguardo inferior
              Expanded(
                child: SafeArea(
                  top: false,
                  left: false,
                  right: false,
                  bottom: true, // Protege la barra de gestos de iOS/Android
                  child: builder(context, scrollController),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}