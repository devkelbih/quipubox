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

  const AppCardBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, child: child);
  }
}
