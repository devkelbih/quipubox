import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import 'drawer/app_drawer.dart';

class AppScaffold extends StatelessWidget {
  /// Recibe cualquier Widget (Text, SvgPicture, Row con Logo, etc.)
  final Widget? title;
  final Widget body;
  final List<Widget>? actions;
  final PreferredSizeWidget? appBarBottom;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.appBarBottom,
  });

  /// Constructor conveniente para vistas con solo título en texto plano
  factory AppScaffold.withTextTitle({
    Key? key,
    required String title,
    required Widget body,
    List<Widget>? actions,
    PreferredSizeWidget? appBarBottom,
  }) {
    return AppScaffold(
      key: key,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      body: body,
      actions: actions,
      appBarBottom: appBarBottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSigningOut = context.select<AuthViewModel, bool>(
      (vm) => vm.isSigningOut,
    );

    return Stack(
      children: [
        AbsorbPointer(
          absorbing: isSigningOut,
          child: Scaffold(
            appBar: AppBar(
              title:
                  title, // Pasa directamente el Widget, limpio y sin ternarios
              leading: Builder(
                builder: (drawerContext) {
                  return IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () => Scaffold.of(drawerContext).openDrawer(),
                  );
                },
              ),
              actions: actions,
              bottom: appBarBottom,
            ),
            drawer: const AppDrawer(),
            body: body,
          ),
        ),
        if (isSigningOut)
          const Positioned.fill(
            child: _BlockingLoaderOverlay(
              text: 'Cerrando sesión...',
              message: 'Espera un momento.',
            ),
          ),
      ],
    );
  }
}

class _BlockingLoaderOverlay extends StatelessWidget {
  final String text;
  final String message;

  const _BlockingLoaderOverlay({required this.text, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: .96),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
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
