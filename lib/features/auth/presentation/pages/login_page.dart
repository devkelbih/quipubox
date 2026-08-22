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

    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;

    final canLogin = !auth.isAuthBusy && isOnline;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ============================================================
          // FONDO
          // ============================================================
          Image.asset(
            'assets/banner_login.jpg',
            fit: BoxFit.cover,
          ),

          // Overlay para mejorar contraste
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(20),
                  Colors.black.withAlpha(45),
                  Colors.black.withAlpha(120),
                ],
              ),
            ),
          ),

          // ============================================================
          // LOGO Y ESLOGAN
          // ============================================================
          Positioned(
            top: MediaQuery.of(context).padding.top + 40,
            left: 24,
            right: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 250,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 10),

                Text(
                  'Simplifica tu operación.\nImpulsa tu negocio.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // ============================================================
          // SHEET DE LOGIN
          // ============================================================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              constraints: BoxConstraints(
                minHeight: screenSize.height * 0.15,
                maxHeight: screenSize.height * 0.35,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(55),
                    blurRadius: 24,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ----------------------------------------------------
                    // Handle
                    // ----------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // ----------------------------------------------------
                    // Contenido
                    // ----------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Botón Google
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: canLogin
                                  ? () async {
                                      final authViewModel =
                                          context.read<AuthViewModel>();

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
                                  ? const SizedBox(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Icon(Icons.login_rounded),
                              label: Text(
                                auth.isSigningIn
                                    ? 'Iniciando sesión...'
                                    : 'Continuar con Google',
                              ),
                            ),
                          ),

                          // ------------------------------------------------
                          // Opciones adicionales
                          // ------------------------------------------------
                          if (isOnline) ...[
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: colorScheme.outlineVariant,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    'o',
                                    style: TextStyle(
                                      color: colorScheme.outline,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: colorScheme.outlineVariant,
                                  ),
                                ),
                              ],
                            ),

                            TextButton(
                              onPressed: canLogin
                                  ? () {
                                      // Solicitar cuenta demo
                                    }
                                  : null,
                              child: const Text(
                                'Solicitar cuenta demo',
                              ),
                            ),
                          ],

                          // ------------------------------------------------
                          // Error de autenticación
                          // ------------------------------------------------
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