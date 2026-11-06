import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/network/connectivity_viewmodel.dart';
import 'package:quipubox/core/network/network_checker.dart';
import 'package:quipubox/core/theme/app_theme.dart';
import 'package:quipubox/features/operaciones/reparto/domain/entities/reparto.dart';
import 'package:quipubox/features/operaciones/reparto/domain/usecases/save_asignaciones_reparto.dart';
import 'package:quipubox/features/operaciones/reparto/domain/usecases/update_reparto.dart';
import 'package:quipubox/features/operaciones/reparto/domain/usecases/save_linea_reparto.dart';
import 'package:quipubox/features/operaciones/reparto/domain/usecases/delete_reparto.dart';
import 'package:quipubox/features/operaciones/reparto/presentation/screens/reparto_detail_screen.dart';
import 'package:quipubox/features/operaciones/reparto/presentation/viewmodels/reparto_detail_viewmodel.dart';
import 'package:quipubox/features/operaciones/reparto/presentation/widgets/asignacion_reparto_form.dart';
import 'package:quipubox/features/operaciones/reparto/presentation/widgets/reparto_linea_form.dart';
import 'reparto_fixtures.dart' as f;

class _Repository extends f.Repository {
  final f.Loader loader;
  _Repository(this.loader);
  @override
  Future<void> createConCalidades(int id, AsignacionReparto a) async {
    await super.createConCalidades(id, a);
    loader.data = f.contextData(
      items: [
        Reparto(
          id: 1,
          detalleId: id,
          operacionId: 44,
          receptorId: a.receptorId,
          puestoId: a.puestoId,
          cantidad: a.cantidad,
          receptor: f.cliente,
          puesto: f.puesto,
          lineas: a.lineas,
        ),
      ],
    );
  }

  @override
  Future<void> addLinea(int id, RepartoLinea l) async {
    await super.addLinea(id, l);
    final old = loader.data.repartos.single;
    loader.data = f.contextData(
      directa: true,
      items: [
        Reparto(
          id: old.id,
          detalleId: 73,
          receptorId: 25,
          puestoId: 221,
          cantidad: 100,
          receptor: f.cliente,
          puesto: f.puesto,
          lineas: [...old.lineas, l],
        ),
      ],
    );
  }
}

RepartoDetailViewModel vmFor(f.Repository repo, f.Loader loader) =>
    RepartoDetailViewModel(
      getContexto: loader,
      saveAsignaciones: SaveAsignacionesRepartoUseCase(
        repository: repo,
        getContexto: loader,
        currentSession: f.Session(),
      ),
      updateReparto: UpdateRepartoUseCase(
        repository: repo,
        getContexto: loader,
        currentSession: f.Session(),
      ),
      saveLinea: SaveLineaRepartoUseCase(
        repository: repo,
        getContexto: loader,
        currentSession: f.Session(),
      ),
      deleteReparto: DeleteRepartoUseCase(
        repository: repo,
        getContexto: loader,
        currentSession: f.Session(),
      ),
    );

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      'Asigna por calidad con precio opcional, cierra formulario y refresca; oscuro=$dark',
      (tester) async {
        tester.view.physicalSize = const Size(390, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final loader = f.Loader(f.contextData());
        final repo = _Repository(loader);
        final vm = vmFor(repo, loader);
        final connectivity = ConnectivityViewModel(
          networkChecker: NetworkChecker(),
        );
        await vm.load(44, 73);
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: vm),
              ChangeNotifierProvider.value(value: connectivity),
            ],
            child: MaterialApp(
              theme: dark ? AppTheme.dark : AppTheme.light,
              home: const RepartoDetailScreen(operacionId: 44, detalleId: 73),
            ),
          ),
        );
        await tester.tap(find.text('Asignar receptor'));
        await tester.pumpAndSettle();
        final receptor = find.byWidgetPredicate(
          (w) =>
              w is DropdownButtonFormField<int> &&
              w.decoration.labelText == 'Receptor',
        );
        await tester.scrollUntilVisible(
          receptor,
          100,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.tap(receptor);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Carla').last);
        await tester.pumpAndSettle();
        final puesto = find.byWidgetPredicate(
          (w) =>
              w is DropdownButtonFormField<int> &&
              w.decoration.labelText == 'Puesto y sección',
        );
        await tester.tap(puesto);
        await tester.pumpAndSettle();
        await tester.tap(find.text('221').last);
        await tester.pumpAndSettle();
        for (final entry in {101: '20', 102: '10'}.entries) {
          final field = find.byKey(ValueKey('reparto-cantidad-${entry.key}'));
          await tester.scrollUntilVisible(
            field,
            120,
            scrollable: find.byType(Scrollable).last,
          );
          await tester.pumpAndSettle();
          await tester.enterText(field, entry.value);
        }
        final save = find.widgetWithText(FilledButton, 'Guardar asignación');
        await tester.scrollUntilVisible(
          save,
          160,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.pumpAndSettle();
        await tester.tap(save);
        await tester.pumpAndSettle();
        expect(repo.calls, ['calidades']);
        expect(repo.saved!.single.cantidad, 30);
        expect(
          repo.saved!.single.lineas.every((l) => l.precio == null),
          isTrue,
        );
        expect(find.byType(AsignacionRepartoForm), findsNothing);
        expect(find.text('Asignaciones (1)'), findsOneWidget);
        expect(
          find.text('30 jabas asignadas · 30 con desglose'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        vm.dispose();
        connectivity.dispose();
      },
    );
  }
  testWidgets('Completa una entrega directa sobre el ítem existente', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const item = Reparto(
      id: 1,
      detalleId: 73,
      receptorId: 25,
      puestoId: 221,
      cantidad: 100,
      receptor: f.cliente,
      puesto: f.puesto,
      lineas: [
        RepartoLinea(
          id: 11,
          idCalidadCarga: 101,
          cantidad: 20,
          nombre: 'Primera',
        ),
      ],
    );
    final loader = f.Loader(f.contextData(directa: true, items: [item]));
    final repo = _Repository(loader);
    final vm = vmFor(repo, loader);
    final connectivity = ConnectivityViewModel(
      networkChecker: NetworkChecker(),
    );
    await vm.load(44, 73);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: vm),
          ChangeNotifierProvider.value(value: connectivity),
        ],
        child: const MaterialApp(
          home: RepartoDetailScreen(operacionId: 44, detalleId: 73),
        ),
      ),
    );
    expect(find.text('Asignar receptor'), findsNothing);
    final add = find.text('Completar desglose');
    await tester.scrollUntilVisible(
      add,
      100,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(add);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Segunda').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Cantidad de jabas'),
      '40',
    );
    final save = find.widgetWithText(FilledButton, 'Guardar calidad');
    await tester.scrollUntilVisible(
      save,
      100,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(repo.calls, ['addLinea']);
    expect(find.byType(RepartoLineaForm), findsNothing);
    expect(vm.data!.repartos.single.cantidadDesglosada, 60);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    vm.dispose();
    connectivity.dispose();
  });
}
