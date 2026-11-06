import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:quipubox/core/navigation/app_routes.dart';
import 'package:quipubox/core/theme/app_theme.dart';
import 'package:quipubox/features/auth/domain/entities/authenticated_user.dart';
import 'package:quipubox/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:quipubox/features/settings/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/get_operaciones_carga.dart';
import 'package:quipubox/features/operaciones/reparto/domain/entities/distribucion_operacion.dart';
import 'package:quipubox/features/operaciones/reparto/domain/entities/reparto.dart';
import 'package:quipubox/features/operaciones/reparto/domain/usecases/get_distribucion_operacion.dart';
import 'package:quipubox/features/operaciones/reparto/presentation/screens/reparto_list_screen.dart';
import 'package:quipubox/features/operaciones/reparto/presentation/screens/reparto_operacion_screen.dart';
import 'package:quipubox/features/operaciones/reparto/presentation/viewmodels/reparto_list_viewmodel.dart';
import 'package:quipubox/features/operaciones/reparto/presentation/viewmodels/reparto_operacion_viewmodel.dart';
import 'package:quipubox/features/operaciones/reparto/presentation/widgets/distribucion_resumen_card.dart';
import 'reparto_fixtures.dart' as f;

class _Auth extends ChangeNotifier implements AuthViewModel {
  @override
  bool get isSigningOut => false;
  @override
  AuthenticatedUser? get user => null;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Settings extends ChangeNotifier implements SettingsViewModel {
  @override
  bool isEffectiveDarkMode(BuildContext context) => false;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Ops implements GetOperacionesCargaUseCase {
  int requests = 0;
  @override
  Future<List<OperacionCarga>> call({String? estado, DateTime? fecha}) async {
    requests++;
    return [f.operation];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Distribution implements GetDistribucionOperacionUseCase {
  int requests = 0;
  DistribucionOperacion data = DistribucionOperacion(
    operacion: f.operation,
    cargas: [f.detail.copyWith(cantidadClasificada: 60)],
    asignaciones: [
      const Reparto(
        id: 1,
        detalleId: 73,
        puestoId: 221,
        receptorId: 25,
        cantidad: 30,
      ),
    ],
  );
  @override
  Future<DistribucionOperacion> call(int id) async {
    requests++;
    return data;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      'Operaciones → distribución → carga, conserva búsqueda y actualiza barras al volver; oscuro=$dark',
      (tester) async {
        tester.view.physicalSize = const Size(390, 950);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final auth = _Auth();
        final settings = _Settings();
        final ops = _Ops();
        final distribution = _Distribution();
        final listVm = RepartoListViewModel(getOperaciones: ops);
        await listVm.load();
        final router = GoRouter(
          initialLocation: AppRoutes.repartos,
          routes: [
            GoRoute(
              path: AppRoutes.repartos,
              builder: (_, _) => ChangeNotifierProvider.value(
                value: listVm,
                child: const RepartoListScreen(),
              ),
              routes: [
                GoRoute(
                  path: ':operationId',
                  builder: (_, state) => ChangeNotifierProvider(
                    create: (_) =>
                        RepartoOperacionViewModel(distribution)..load(44),
                    child: const RepartoOperacionScreen(operacionId: 44),
                  ),
                  routes: [
                    GoRoute(
                      path: 'cargas/:detailId',
                      builder: (context, _) => Scaffold(
                        appBar: AppBar(title: const Text('Detalle de carga')),
                        body: TextButton(
                          onPressed: () {
                            distribution.data = DistribucionOperacion(
                              operacion: f.operation,
                              cargas: [f.detail],
                              asignaciones: [
                                const Reparto(
                                  id: 1,
                                  detalleId: 73,
                                  puestoId: 221,
                                  receptorId: 25,
                                  cantidad: 100,
                                ),
                              ],
                            );
                            context.pop(true);
                          },
                          child: const Text('Guardar y volver'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthViewModel>.value(value: auth),
              ChangeNotifierProvider<SettingsViewModel>.value(value: settings),
            ],
            child: MaterialApp.router(
              theme: dark ? AppTheme.dark : AppTheme.light,
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(DropdownButtonFormField<int>), findsNothing);
        expect(find.textContaining('Operación #44'), findsOneWidget);
        expect(distribution.requests, 0);
        await tester.tap(find.byType(TextField));
        await tester.pump(const Duration(milliseconds: 500));
        expect(ops.requests, 1);
        await tester.enterText(find.byType(TextField), '44');
        await tester.pump(const Duration(milliseconds: 400));
        await tester.tap(find.text('Ver distribución'));
        await tester.pumpAndSettle();
        expect(distribution.requests, 1);
        final summaryBars = find.descendant(
          of: find.byType(DistribucionResumenCard),
          matching: find.byType(LinearProgressIndicator),
        );
        expect(
          tester
              .widgetList<LinearProgressIndicator>(summaryBars)
              .map((b) => b.value),
          [.3, .6],
        );
        final open = find.text('Gestionar distribución');
        await tester.scrollUntilVisible(
          open,
          160,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.pumpAndSettle();
        await tester.tap(open);
        await tester.pumpAndSettle();
        expect(find.text('Detalle de carga'), findsOneWidget);
        await tester.tap(find.text('Guardar y volver'));
        await tester.pumpAndSettle();
        expect(distribution.requests, 2);
        await tester.scrollUntilVisible(
          find.byType(DistribucionResumenCard),
          -200,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.pumpAndSettle();
        expect(
          tester
              .widgetList<LinearProgressIndicator>(summaryBars)
              .map((b) => b.value),
          [1.0, 1.0],
        );
        router.pop();
        await tester.pumpAndSettle();
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          '44',
        );
        expect(ops.requests, 1);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        router.dispose();
        listVm.dispose();
        auth.dispose();
        settings.dispose();
      },
    );
  }
}
