import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo con imagen banner
          Image.asset(
            'assets/banner.jpg',
            fit: BoxFit.cover,
          ),

          // Overlay oscuro para mejorar la legibilidad
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(102),
                  Colors.black.withAlpha(179),
                ],
              ),
            ),
          ),

          // Contenido centrado
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Image.asset(
                  'assets/logo.png',
                  height: screenSize.width * 0.50,
                  width: screenSize.width * 0.50,
                  fit: BoxFit.contain,
                ),

                // Slogan pegado al logo
                const Text(
                  'Conecta. Gestiona. Crece.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                // Separación antes de la carga
                const SizedBox(height: 40),

                // Indicador de carga
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                ),

                const SizedBox(height: 14),

                // Texto de carga
                const Text(
                  'Cargando...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Footer con versión
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Versión 1.0.0',
                style: TextStyle(
                  color: Colors.white.withAlpha(102),
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}