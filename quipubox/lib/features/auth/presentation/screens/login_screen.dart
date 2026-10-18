import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/connectivity_viewmodel.dart';
import '../../../../core/ui/sheets/app_bottom_sheet.dart';
import '../widgets/login_auth_sheet_content.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _openAuthSheet(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      title: 'Iniciar sesión',
      initialChildSize: 0.35,
      minChildSize: 0.25,
      maxChildSize: 0.40,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: const LoginAuthSheetContent(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityViewModel>().isOnline;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo
          Image.asset(
            'assets/banner_login.jpg',
            fit: BoxFit.cover,
          ),

          // Overlay oscuro para contraste
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(30),
                  Colors.black.withAlpha(150),
                  Colors.black.withAlpha(180),
                ],
              ),
            ),
          ),

          // Marca y Botón de ingreso principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const Spacer(),

                  // Logo y Eslogan
                  Image.asset(
                    'assets/logo.png',
                    width: 240,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Simplifica tu operación.\nImpulsa tu negocio.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                  ),

                  const Spacer(),

                  // Botón único "Ingresar"
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: isOnline ? () => _openAuthSheet(context) : null,
                      child: Text(
                        isOnline ? 'Ingresar' : 'Sin conexión a internet',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}