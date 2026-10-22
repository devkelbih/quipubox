import 'package:flutter/material.dart';

/// Distribuye datos en una o dos columnas iguales, sin alterar su presentación.
class AppCardInfoGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;

  const AppCardInfoGrid({
    super.key,
    required this.children,
    this.spacing = 12,
    this.runSpacing = 8,
  }) : assert(spacing >= 0),
       assert(runSpacing >= 0);

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Reserva ancho legible para cada dato, también con texto ampliado.
        final minColumnWidth =
            140 * (MediaQuery.textScalerOf(context).scale(14) / 14);
        final columns =
            constraints.hasBoundedWidth &&
                constraints.maxWidth >= minColumnWidth * 2 + spacing
            ? 2
            : 1;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < children.length; index += columns) ...[
              if (index > 0) SizedBox(height: runSpacing),
              if (columns == 1)
                children[index]
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: children[index]),
                    SizedBox(width: spacing),
                    Expanded(
                      child: index + 1 < children.length
                          ? children[index + 1]
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
            ],
          ],
        );
      },
    );
  }
}
