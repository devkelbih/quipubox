import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_routes.dart';
import '../drawer/app_drawer.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final List<Widget>? actions;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final canPop = router.canPop();
    final isHome = GoRouterState.of(context).matchedLocation == AppRoutes.home;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        leading: canPop && !isHome
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  if (router.canPop()) {
                    router.pop();
                  } else {
                    context.go(AppRoutes.home);
                  }
                },
              )
            : Builder(
                builder: (drawerContext) => IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () => Scaffold.of(drawerContext).openDrawer(),
                ),
              ),
        actions: actions,
      ),
      drawer: const AppDrawer(),
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}