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

    final canLogin = !auth.isLoading && isOnline;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.inventory_2_rounded,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Quipubox',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Control logístico de jabas, cargas y entregas.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      FilledButton.icon(
                        onPressed: canLogin
                            ? () async {
                                final authViewModel =
                                    context.read<AuthViewModel>();

                                final ok =
                                    await authViewModel.loginWithGoogle();

                                if (!ok) {
                                  AppToast.show(
                                    authViewModel.errorMessage ??
                                        'No se pudo iniciar sesión.',
                                    type: ToastType.error,
                                  );
                                }
                              }
                            : null,
                        icon: auth.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.login_rounded),
                        label: const Text('Continuar con Google'),
                      ),

                      if (!isOnline) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Se requiere conexión a internet para iniciar sesión.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],

                      if (auth.errorMessage != null) ...[
                        const SizedBox(height: 14),
                        Text(
                          auth.errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}