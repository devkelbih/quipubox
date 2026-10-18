import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/connectivity_viewmodel.dart';
import '../../../../core/ui/feedback/app_toast.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginAuthSheetContent extends StatelessWidget {
  const LoginAuthSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final isOnline = context.watch<ConnectivityViewModel>().isOnline;
    final colorScheme = Theme.of(context).colorScheme;

    final canLogin = !auth.isAuthBusy && isOnline;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Botón Google
        SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: canLogin
                ? () async {
                    final authViewModel = context.read<AuthViewModel>();
                    final ok = await authViewModel.loginWithGoogle();

                    if (!context.mounted) return;

                    if (ok) {
                      Navigator.pop(
                        context,
                      ); // Cierra el sheet al loguearse con éxito
                    } else {
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
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.login_rounded),
            label: Text(
              auth.isSigningIn ? 'Iniciando sesión...' : 'Continuar con Google',
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Separador u opciones secundarias
        Row(
          children: [
            Expanded(child: Divider(color: colorScheme.outlineVariant)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'o',
                style: TextStyle(
                  color: colorScheme.outline,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: colorScheme.outlineVariant)),
          ],
        ),

        TextButton(
          onPressed: canLogin
              ? () {
                  // Solicitar cuenta demo
                }
              : null,
          child: const Text('Solicitar cuenta demo'),
        ),

        // Error si ocurre
        if (auth.errorMessage != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: colorScheme.onErrorContainer,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    auth.errorMessage!,
                    style: TextStyle(
                      color: colorScheme.onErrorContainer,
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
    );
  }
}
