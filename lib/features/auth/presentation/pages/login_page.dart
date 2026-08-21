import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/connectivity_viewmodel.dart';
import '../../../../core/ui/feedback/app_toast.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final isOnline = context.watch<ConnectivityViewModel>().isOnline;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    final canLogin = !auth.isAuthBusy && isOnline;

    return Scaffold(
      body: Column(
        children: [
          // Parte superior: Banner con logo
          SizedBox(
            height: screenHeight * 0.70,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Banner de fondo
                Image.asset('assets/banner_2.png', fit: BoxFit.cover),

                // Overlay oscuro para mejor visibilidad del logo
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withAlpha(30),
                        Colors.black.withAlpha(26),
                        Colors.black.withAlpha(128),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Parte inferior: Login con efecto sheets
          SizedBox(
            height: screenHeight * 0.30,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(38),
                    blurRadius: 20,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Handle del sheets
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 8),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),

                    // Contenido
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Botón de Google
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: canLogin
                                    ? () async {
                                        final authViewModel = context
                                            .read<AuthViewModel>();
                                        final ok = await authViewModel
                                            .loginWithGoogle();
                                        if (!ok) {
                                          AppToast.show(
                                            authViewModel.errorMessage ??
                                                'No se pudo iniciar sesión.',
                                            type: ToastType.error,
                                          );
                                        }
                                      }
                                    : null,
                                icon: auth.isSigningIn
                                    ? SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Icon(Icons.login_rounded),
                                label: Text(
                                  auth.isSigningIn
                                      ? 'Iniciando sesión...'
                                      : 'Continuar con Google',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                  ),
                                  elevation: 2,
                                  shadowColor: Colors.black.withAlpha(26),
                                ),
                              ),
                            ),

                            // Divider o
                            if (isOnline) ...[
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey.shade300,
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      'o',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey.shade300,
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Opción demo
                              TextButton(
                                onPressed: canLogin
                                    ? () {
                                        // Opción de demo
                                      }
                                    : null,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                                child: Text(
                                  'Solicitar cuenta demo',
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],

                            // Mensaje de error de conexión
                            if (!isOnline) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: colorScheme.error.withAlpha(20),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colorScheme.error.withAlpha(51),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.wifi_off_rounded,
                                      color: colorScheme.error,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Se requiere conexión a internet para iniciar sesión.',
                                        style: TextStyle(
                                          color: colorScheme.error,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            // Mensaje de error de autenticación
                            if (auth.errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colorScheme.error.withAlpha(20),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline_rounded,
                                      color: colorScheme.error,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        auth.errorMessage!,
                                        style: TextStyle(
                                          color: colorScheme.error,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
