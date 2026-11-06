import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/navigation/app_exit_handler.dart';
import '../../../../core/ui/feedback/app_blocking_loader_overlay.dart';
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        AppExitHandler.handlePop(context);
      },
      child: Stack(
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
              body: SafeArea(
                top: false, // El AppBar ya protege la parte superior
                child: body,
              ),
            ),
          ),
          if (isSigningOut)
            const Positioned.fill(
              child: AppBlockingLoaderOverlay(
                text: 'Cerrando sesión...',
                message: 'Espera un momento.',
              ),
            ),
        ],
      ),
    );
  }
}
