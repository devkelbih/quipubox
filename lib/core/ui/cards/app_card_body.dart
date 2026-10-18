import 'package:flutter/material.dart';

/// ===============================================================
/// AppCardBody
/// ---------------------------------------------------------------
/// Contenedor reutilizable para mostrar la información principal
/// de una tarjeta.
///
/// No conoce la entidad.
/// No conoce los datos.
/// No conoce el tipo de información.
///
/// Solo define el estilo visual del cuerpo.
/// ===============================================================
class AppCardBody extends StatelessWidget {
  final Widget child;

  const AppCardBody({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}