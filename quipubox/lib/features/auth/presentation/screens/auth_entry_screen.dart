import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/connectivity_viewmodel.dart';
import '../../../../core/ui/sheets/app_bottom_sheet.dart';
import '../widgets/login_auth_sheet_content.dart';
import '../viewmodels/auth_viewmodel.dart';

class AuthEntryScreen extends StatelessWidget {
  final bool isCheckingSession;

  const AuthEntryScreen({super.key, required this.isCheckingSession});

  void _openAuthSheet(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      title: 'Iniciar sesión',
      initialChildSize: 0.35,
      minChildSize: 0.30,
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
    final signingIn = context.select<AuthViewModel, bool>(
      (auth) => auth.isSigningIn,
    );
    final loading = isCheckingSession || signingIn;
    final preparingProfile = context.select<AuthViewModel, bool>(
      (auth) => auth.isPreparingProfile,
    );

    return PopScope(
      canPop: !signingIn && !preparingProfile,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen de fondo
            Image.asset('assets/banner.png', fit: BoxFit.cover),

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    const Spacer(),

                    // Logo y Eslogan
                    Image.asset(
                      'assets/logo-horizontal.png',
                      width: 240,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 76,
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Text(
                            loading
                                ? 'Conecta. Gestiona. Crece.'
                                : 'Simplifica tu operación.\nImpulsa tu negocio.',
                            key: ValueKey(loading),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Botón único "Ingresar"
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: loading
                            ? const Center(
                                key: ValueKey('loading'),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Cargando...',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
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
                                  onPressed: isOnline
                                      ? () => _openAuthSheet(context)
                                      : null,
                                  child: Text(
                                    isOnline
                                        ? 'Ingresar'
                                        : 'Sin conexión a internet',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
      ),
    );
  }
}
