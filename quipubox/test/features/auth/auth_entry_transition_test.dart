import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/navigation/app_router.dart';
import 'package:quipubox/core/network/connectivity_viewmodel.dart';
import 'package:quipubox/core/network/network_checker.dart';
import 'package:quipubox/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:quipubox/app/app.dart';
import 'package:quipubox/core/state/safe_change_notifier.dart';
import 'package:quipubox/features/settings/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quipubox/features/auth/presentation/widgets/login_auth_sheet_content.dart';

class _Auth extends ChangeNotifier implements AuthViewModel {
  bool checking = true;
  bool signingIn = false;
  bool preparing = false;

  @override
  bool get isCheckingSession => checking;

  @override
  bool get canOpenApp => false;

  @override
  bool get isSigningIn => signingIn;

  @override
  bool get isPreparingProfile => preparing;

  @override
  bool get isAuthBusy => signingIn || preparing;

  @override
  bool get hasSupabaseSession => preparing;

  @override
  bool get hasProfile => false;

  @override
  String? get errorMessage => null;

  void finishChecking() {
    checking = false;
    notifyListeners();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Settings extends SafeChangeNotifier implements SettingsViewModel {
  @override
  ThemeMode get themeMode => ThemeMode.light;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Finder _asset(String path) => find.byWidgetPredicate(
  (widget) =>
      widget is Image &&
      widget.image is AssetImage &&
      (widget.image as AssetImage).assetName == path,
);

void main() {
  testWidgets('La preparación del perfil cubre también el sheet de Google', (
    tester,
  ) async {
    final auth = _Auth()..checking = false;
    final settings = _Settings();
    final appRouter = AppRouter(auth);
    final connectivity = ConnectivityViewModel(
      networkChecker: NetworkChecker(),
    );
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthViewModel>.value(value: auth),
          ChangeNotifierProvider<SettingsViewModel>.value(value: settings),
          ChangeNotifierProvider<ConnectivityViewModel>.value(
            value: connectivity,
          ),
          Provider<AppRouter>.value(value: appRouter),
        ],
        child: const QuipuboxApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginAuthSheetContent), findsOneWidget);

    auth.signingIn = true;
    auth.preparing = true;
    auth.notifyListeners();
    await tester.pump();
    expect(find.text('Preparando tu cuenta...'), findsOneWidget);
    expect(find.byType(LoginAuthSheetContent), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is AbsorbPointer && widget.absorbing,
      ),
      findsOneWidget,
    );
    expect(appRouter.router.routeInformationProvider.value.uri.path, '/login');
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    appRouter.router.dispose();
    connectivity.dispose();
    settings.dispose();
    auth.dispose();
  });

  testWidgets('Splash y login conservan el fondo y la posición del logo', (
    tester,
  ) async {
    final auth = _Auth();
    final router = AppRouter(auth).router;
    final connectivity = ConnectivityViewModel(
      networkChecker: NetworkChecker(),
    );
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ConnectivityViewModel>.value(
            value: connectivity,
          ),
          ChangeNotifierProvider<AuthViewModel>.value(value: auth),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    final banner = _asset('assets/banner.png');
    final logo = _asset('assets/logo-horizontal.png');
    final bannerElement = tester.element(banner);
    final logoElement = tester.element(logo);
    final logoBounds = tester.getRect(logo);
    expect(find.text('Cargando...'), findsOneWidget);
    expect(find.text('Ingresar'), findsNothing);

    auth.finishChecking();
    await tester.pump();
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, '/login');
    expect(tester.element(banner), same(bannerElement));
    expect(tester.element(logo), same(logoElement));
    expect(tester.getRect(logo), logoBounds);
    expect(find.text('Ingresar'), findsOneWidget);
    expect(find.text('Cargando...'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    router.dispose();
    connectivity.dispose();
    auth.dispose();
  });
}
