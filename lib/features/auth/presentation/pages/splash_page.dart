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
            'assets/banner_2.png',
            fit: BoxFit.cover,
          ),
          
          // Overlay oscuro para mejor legibilidad
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/logo_dark.png',
                  height: screenSize.width * 0.25,
                  width: screenSize.width * 0.25,
                  fit: BoxFit.contain,
                ),
                
                const SizedBox(height: 20),
                
                // Título principal
                const Text(
                  'Quipubox',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Subtítulo
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade400,
                        Colors.blue.shade700,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'controla · gestiona · entrega',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Indicador de carga con diseño moderno
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
                    strokeWidth: 3,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Texto de carga
                const Text(
                  'Cargando...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          // Footer con versión (opcional)
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