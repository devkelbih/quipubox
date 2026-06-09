import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_toast.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 86,
                    width: 86,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [colors.primary, colors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: .22),
                          blurRadius: 30,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Icon(Icons.inventory_2_rounded, size: 42, color: colors.onPrimary),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Bienvenido a Quipubox',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Control operativo de cargas, repartos, jabas, clientes, sedes y evidencias para empresas logísticas.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colors.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Acceso seguro',
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 8),
                          Text(
                            'La app solo permite iniciar sesión con Google mediante Supabase Auth.',
                            style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: auth.isLoading
                                ? null
                                : () async {
                                    await context.read<AuthViewModel>().loginWithGoogle();
                                    if (context.mounted && context.read<AuthViewModel>().errorMessage != null) {
                                      AppToast.show(
                                        context,
                                        message: context.read<AuthViewModel>().errorMessage!,
                                        type: ToastType.error,
                                      );
                                    }
                                  },
                            icon: auth.isLoading
                                ? SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: colors.onPrimary),
                                  )
                                : const Icon(Icons.login_rounded),
                            label: Text(auth.isLoading ? 'Conectando...' : 'Continuar con Google'),
                          ),
                          if (auth.errorMessage != null) ...[
                            const SizedBox(height: 14),
                            Text(auth.errorMessage!, style: TextStyle(color: colors.error)),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'No se usa acceso tradicional por correo y contraseña.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
