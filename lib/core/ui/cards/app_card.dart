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

  const AppCard({super.key, required this.header, this.body, this.actions});

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
          children: [
            header,

            if (body != null) ...[SizedBox(height: 14), body!],

            if (actions != null) ...[SizedBox(height: 14), actions!],
          ],
        ),
      ),
    );
  }
}
