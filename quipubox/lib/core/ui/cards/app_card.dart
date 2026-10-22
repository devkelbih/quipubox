import 'package:flutter/material.dart';

/// ===============================================================
/// AppCard
/// ---------------------------------------------------------------
/// Tarjeta reutilizable para representar información dentro de
/// Quipubox.
///
/// Se compone de:
///
/// • Header
/// • Body
/// • Actions (opcional)
///
/// No conoce ninguna entidad ni lógica de negocio.
/// ===============================================================
class AppCard extends StatelessWidget {
  final Widget header;
  final Widget? body;
  final Widget? actions;

  /// Footer prioritario. `actions` se conserva para consumidores existentes.
  final Widget? quickActions;

  const AppCard({
    super.key,
    required this.header,
    this.body,
    this.actions,
    this.quickActions,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: scheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,

            if (body != null) ...[const SizedBox(height: 10), body!],

            if (actions != null) actions!,
            if (quickActions != null) quickActions!,
          ],
        ),
      ),
    );
  }
}
