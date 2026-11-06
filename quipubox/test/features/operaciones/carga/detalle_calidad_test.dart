import 'package:quipubox/core/ui/cards/app_card.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/update_calidad_detalle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/detalle_carga.dart';
import 'package:quipubox/features/catalogos/frutas/domain/entities/fruta.dart';
import 'package:quipubox/features/catalogos/variedades/domain/entities/variedad.dart';
import 'package:quipubox/features/catalogos/tipos_jaba/domain/entities/tipos_jaba.dart';
import 'package:quipubox/features/catalogos/tipos_jaba/domain/enums/tipo_material_jaba.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente.dart';
import 'package:quipubox/core/theme/app_theme.dart';
import 'package:quipubox/features/operaciones/carga/presentation/screens/carga_detail_screen.dart';
import 'package:quipubox/features/operaciones/carga/presentation/viewmodels/carga_viewmodel.dart';
import 'package:quipubox/features/operaciones/carga/presentation/widgets/detalle_calidad_form.dart';
import 'package:quipubox/core/network/api_client.dart';
import 'package:quipubox/features/catalogos/calidades/domain/entities/calidad.dart';
import 'package:quipubox/features/catalogos/calidades/domain/repositories/calidad_repository.dart';
import 'package:quipubox/features/catalogos/calidades/domain/usecases/get_calidades.dart';
import 'package:quipubox/features/operaciones/carga/data/datasources/operacion_carga_remote_data_source.dart';
import 'package:quipubox/features/operaciones/carga/data/models/detalle_carga_calidad_model.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/detalle_carga_calidad.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/add_calidad_detalle.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/get_calidades_detalle.dart';
import 'package:quipubox/features/operaciones/carga/presentation/viewmodels/detalle_calidad_viewmodel.dart';

import 'carga_details_test.dart' as fixtures;

class _Repository extends fixtures.Repository {
  int updates = 0;
  @override
  Future<DetalleCargaCalidad> updateCalidadDetalle(
    DetalleCargaCalidad item,
  ) async {
    updates++;
    saved = item;
    return item;
  }

  @override
  Future<List<DetalleCarga>> getDetalles(int id) async =>
      (await super.getDetalles(
        id,
      )).map((item) => item.copyWith(cantidadJabas: 100)).toList();
  DetalleCargaCalidad? saved;
  @override
  Future<List<DetalleCargaCalidad>> getCalidadesDetalle(int detalleId) async =>
      [
        DetalleCargaCalidad(
          id: 101,
          idDetalleCarga: detalleId,
          idCalidad: 1,
          cantidad: 20,
        ),
      ];
  @override
  Future<DetalleCargaCalidad> addCalidadDetalle(
    DetalleCargaCalidad calidad,
  ) async {
    saved = calidad;
    return calidad;
  }
}

class _Catalogo implements CalidadRepository {
  int requests = 0;
  bool fail = false;
  @override
  Future<List<Calidad>> getAll() async {
    requests++;
    if (fail) throw StateError('Catálogo no disponible');
    return const [
      Calidad(id: 1, nombre: 'Primera'),
      Calidad(id: 2, nombre: 'Segunda'),
      Calidad(id: 3, nombre: 'Inactiva', estado: false),
      Calidad(id: 4, nombre: 'Tercera'),
    ];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _LayoutRepository extends _Repository {
  final DetalleCarga detalle;
  _LayoutRepository(this.detalle);

  @override
  Future<List<DetalleCarga>> getDetalles(int id) async => [detalle];

  @override
  Future<List<DetalleCargaCalidad>> getCalidadesDetalle(int detalleId) async =>
      [
        DetalleCargaCalidad(
          idDetalleCarga: detalleId,
          idCalidad: 1,
          cantidad: 20,
          precioUnitario: 7.25,
          nombreCalidad: 'I',
        ),
      ];
}

DetalleCalidadViewModel _vm(_Repository repository) => DetalleCalidadViewModel(
  getCalidades: GetCalidadesUseCase(repository: _Catalogo()),
  getRegistradas: GetCalidadesDetalleUseCase(repository: repository),
  updateCalidad: UpdateCalidadDetalleUseCase(
    repository: repository,
    currentSession: fixtures.Session(),
  ),
  addCalidad: AddCalidadDetalleUseCase(
    repository: repository,
    currentSession: fixtures.Session(),
  ),
);

class _Api extends ApiClient {
  String? path;
  Map<String, dynamic>? body;
  @override
  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    this.path = path;
    this.body = body;
    return {
      'id_detalle_carga_calidad': 90,
      'id_detalle_carga': 73,
      ...?body,
      'calidades': {'nombre': 'Segunda'},
    };
  }
}

void main() {
  test(
    'Editar calidad reemplaza su cantidad sin duplicarla y permite quitar precio',
    () async {
      final repository = _Repository();
      final vm = _vm(repository);
      await vm.load(73);
      final original = vm.registradas.single;
      vm.registradas = [
        original,
        const DetalleCargaCalidad(
          id: 102,
          idDetalleCarga: 73,
          idCalidad: 2,
          cantidad: 60,
        ),
      ];
      expect(
        await vm.save(
          idCalidad: 1,
          cantidad: '41',
          precio: '',
          cantidadTotal: 100,
          editing: original,
        ),
        isFalse,
      );
      expect(repository.updates, 0);
      expect(
        await vm.save(
          idCalidad: 1,
          cantidad: '40',
          precio: '',
          cantidadTotal: 100,
          editing: original,
        ),
        isTrue,
      );
      expect(repository.updates, 1);
      expect(vm.registradas.length, 2);
      expect(vm.cantidadAsignada, 100);
      expect(repository.saved!.precioUnitario, isNull);
      vm.dispose();
    },
  );
  testWidgets(
    'No cuenta dos veces el borrador al recibir el registro guardado',
    (tester) async {
      final repository = _Repository();
      final vm = _vm(repository);
      final controller = ScrollController();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: vm,
          child: MaterialApp(
            home: Scaffold(
              body: DetalleCalidadForm(
                detalleId: 73,
                cantidadTotal: 100,
                scrollController: controller,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(DetalleCalidadForm),
          matching: find.byType(AppCard),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.descendant(
            of: find.byType(DetalleCalidadForm),
            matching: find.byType(AppCard),
          ),
          matching: find.byType(TextField),
        ),
        findsNothing,
      );
      await tester.scrollUntilVisible(
        find.byType(DropdownButtonFormField<int>),
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Segunda').last);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.widgetWithText(TextField, 'Cantidad de jabas'),
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Cantidad de jabas'),
        '60',
      );
      await tester.pump();
      expect(
        await vm.save(
          cantidadTotal: 100,
          idCalidad: 2,
          cantidad: '60',
          precio: '',
        ),
        isTrue,
      );
      await tester.pump();
      expect(find.textContaining('La cantidad supera'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(
        find.byType(LinearProgressIndicator),
        -100,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        .8,
      );
      expect(repository.saved!.precioUnitario, isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
      vm.dispose();
    },
  );
  test(
    'Bloquea exceso sin enviar y permite completar exactamente la carga',
    () async {
      final repository = _Repository();
      final vm = _vm(repository);
      await vm.load(73);
      expect(vm.cantidadAsignada, 20);
      expect(
        await vm.save(
          cantidadTotal: 100,
          idCalidad: 2,
          cantidad: '81',
          precio: '',
        ),
        isFalse,
      );
      expect(repository.saved, isNull);
      expect(vm.errorMessage, contains('superar'));
      expect(
        await vm.save(
          cantidadTotal: 100,
          idCalidad: 2,
          cantidad: '80',
          precio: '',
        ),
        isTrue,
      );
      expect(vm.cantidadAsignada, 100);
      expect(repository.saved!.cantidad, 80);
      vm.dispose();
    },
  );
  test(
    'La ficha carga registradas sin consultar ni depender del catálogo',
    () async {
      final repository = _Repository();
      final catalogo = _Catalogo()..fail = true;
      final vm = DetalleCalidadViewModel(
        getCalidades: GetCalidadesUseCase(repository: catalogo),
        getRegistradas: GetCalidadesDetalleUseCase(repository: repository),
        updateCalidad: UpdateCalidadDetalleUseCase(
          repository: repository,
          currentSession: fixtures.Session(),
        ),
        addCalidad: AddCalidadDetalleUseCase(
          repository: repository,
          currentSession: fixtures.Session(),
        ),
      );
      await vm.loadRegistradas(73);
      expect(catalogo.requests, 0);
      expect(vm.loaded, isTrue);
      expect(vm.errorMessage, isNull);
      expect(vm.registradas.single.cantidad, 20);
      expect(vm.catalogo, isEmpty);
      catalogo.fail = false;
      await vm.load(73);
      expect(catalogo.requests, 1);
      expect(vm.catalogo.length, 4);
      expect(vm.disponibles.map((c) => c.id), [2, 4]);
      vm.dispose();
    },
  );
  for (final dark in [false, true]) {
    testWidgets(
      'Dos líneas, apodo y menú con lectura de precios; oscuro=$dark',
      (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        const detalle = DetalleCarga(
          id: 73,
          idClienteEmisor: 1,
          idFruta: 1,
          idTipoJaba: 1,
          cantidadJabas: 100,
          esReparto: true,
          fruta: Fruta(nombre: 'Uva'),
          variedad: Variedad(idFruta: 1, nombre: 'Tipsom'),
          tipoJaba: TiposJaba(
            nombre: 'Cuadrada',
            tipoMaterial: TipoMaterialJaba.madera,
          ),
          calidades: ['I', 'II'],
          clienteEmisor: Cliente(
            nombres: 'Eduardo',
            apellidos: 'Pérez',
            apodo: ' Lalito ',
          ),
        );
        final repository = _LayoutRepository(detalle);
        final carga = fixtures.viewModel(repository);
        final operation = OperacionCarga(
          id: 44,
          idSedeOrigen: 1,
          idCamion: 2,
          fechaCarga: DateTime(2026),
          estado: 'en_curso',
        );
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<CargaViewModel>.value(value: carga),
              Provider<DetalleCalidadViewModel Function()>.value(
                value: () => _vm(repository),
              ),
            ],
            child: MaterialApp(
              theme: dark ? AppTheme.dark : AppTheme.light,
              home: CargaDetailScreen(operationId: 44, operation: operation),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Uva (Tipsom) - I, II'), findsOneWidget);
        expect(find.text('E: Eduardo Pérez - Reparto'), findsOneWidget);
        expect(find.byIcon(Icons.timelapse_rounded), findsOneWidget);
        final tile = tester.widget<ListTile>(find.byType(ListTile));
        expect((tile.title! as Tooltip).child, isA<Text>());
        expect(((tile.title! as Tooltip).child as Text).maxLines, 1);
        expect(
          ((((tile.subtitle! as Row).children.first as Expanded).child
                          as Tooltip)
                      .child
                  as Text)
              .maxLines,
          1,
        );
        expect(find.byType(ReorderableListView), findsNothing);
        await tester.tap(find.byTooltip('Opciones de carga'));
        await tester.pumpAndSettle();
        final entries = tester
            .widgetList<PopupMenuItem<String>>(
              find.byType(PopupMenuItem<String>),
            )
            .toList();
        expect(entries.map((item) => item.value), [
          'ver',
          'editar',
          'calidad',
          'eliminar',
        ]);
        expect(entries[1].enabled, isTrue);
        expect(entries[2].enabled, isTrue);
        expect(entries[3].enabled, isTrue);
        await tester.tap(find.text('Ver detalle'));
        await tester.pumpAndSettle();
        expect(find.text('100 jabas · Uva (Tipsom)'), findsOneWidget);
        expect(find.text('Tipo de jaba'), findsOneWidget);
        expect(find.text('Variedad'), findsNothing);
        expect(find.text('Receptor'), findsNothing);
        expect(find.text('Retorno de jabas'), findsOneWidget);
        final price = find.text('20 jabas · Precio unitario: 7.25');
        await tester.scrollUntilVisible(
          price,
          200,
          scrollable: find.byType(Scrollable).last,
        );
        expect(price, findsOneWidget);
        expect(find.text('Agregar calidad'), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        carga.dispose();
      },
    );
  }

  testWidgets(
    'Omite variedad y calidades vacías; identifica receptor faltante',
    (tester) async {
      const detalle = DetalleCarga(
        id: 73,
        idClienteEmisor: 1,
        idFruta: 1,
        idTipoJaba: 1,
        cantidadJabas: 100,
        fruta: Fruta(nombre: 'Pera'),
        tipoJaba: TiposJaba(
          nombre: 'Perera',
          tipoMaterial: TipoMaterialJaba.madera,
        ),
        clienteEmisor: Cliente(
          nombres: 'Eduardo',
          apellidos: 'Pérez',
          apodo: ' ',
        ),
      );
      final carga = fixtures.viewModel(_LayoutRepository(detalle));
      final operation = OperacionCarga(
        id: 44,
        idSedeOrigen: 1,
        idCamion: 2,
        fechaCarga: DateTime(2026),
        estado: 'repartiendo',
      );
      await tester.pumpWidget(
        ChangeNotifierProvider<CargaViewModel>.value(
          value: carga,
          child: MaterialApp(
            home: CargaDetailScreen(operationId: 44, operation: operation),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Pera - Sin clasificar'), findsOneWidget);
      expect(find.textContaining('Sin registrar'), findsNothing);
      expect(find.text('E: Eduardo Pérez - Reparto'), findsOneWidget);
      await tester.tap(find.byTooltip('Opciones de carga'));
      await tester.pumpAndSettle();
      final add = tester
          .widgetList<PopupMenuItem<String>>(find.byType(PopupMenuItem<String>))
          .singleWhere((item) => item.value == 'calidad');
      expect(add.enabled, isFalse);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      carga.dispose();
    },
  );

  testWidgets(
    'Tres puntos abre el formulario y guardar refresca solo los detalles',
    (tester) async {
      final repository = _Repository();
      final carga = fixtures.viewModel(repository);
      final operation = OperacionCarga(
        id: 44,
        idSedeOrigen: 1,
        idCamion: 2,
        fechaCarga: DateTime(2026),
        estado: 'en_curso',
      );
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CargaViewModel>.value(value: carga),
            Provider<DetalleCalidadViewModel Function()>.value(
              value: () => _vm(repository),
            ),
          ],
          child: MaterialApp(
            home: CargaDetailScreen(operationId: 44, operation: operation),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Opciones de carga'));
      await tester.pumpAndSettle();
      expect(find.text('Ver información'), findsNothing);
      await tester.tap(find.text('Ver detalle'));
      await tester.pumpAndSettle();
      final register = find.widgetWithText(FilledButton, 'Registrar calidad');
      await tester.scrollUntilVisible(
        register,
        160,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(register);
      await tester.pumpAndSettle();
      await tester.tap(register);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(DetalleCalidadForm),
          matching: find.byType(AppCard),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.descendant(
            of: find.byType(DetalleCalidadForm),
            matching: find.byType(AppCard),
          ),
          matching: find.byType(TextField),
        ),
        findsNothing,
      );
      await tester.scrollUntilVisible(
        find.byType(DropdownButtonFormField<int>),
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Segunda').last);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.widgetWithText(TextField, 'Cantidad de jabas'),
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Cantidad de jabas'),
        '60',
      );
      await tester.scrollUntilVisible(
        find.widgetWithText(TextField, 'Precio unitario (opcional)'),
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Precio unitario (opcional)'),
        '',
      );
      final save = find.widgetWithText(FilledButton, 'Agregar calidad');
      await tester.scrollUntilVisible(
        save,
        160,
        scrollable: find
            .descendant(
              of: find.byType(DetalleCalidadForm),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.tap(save);
      await tester.pump();
      expect(find.textContaining('La cantidad supera'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();
      expect(repository.saved!.idDetalleCarga, 10);
      expect(repository.saved!.idCalidad, 2);
      expect(repository.saved!.cantidad, 60);
      expect(repository.saved!.precioUnitario, isNull);
      expect(repository.detailsRequests, 2);
      expect(repository.headerRequests, 0);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      carga.dispose();
    },
  );

  test(
    'Contrato real usa detalle-carga, cantidad y precio numérico opcional',
    () async {
      final api = _Api();
      final dataSource = OperacionCargaRemoteDataSource(apiClient: api);
      final result = await dataSource.addCalidadDetalle(
        const DetalleCargaCalidad(
          idDetalleCarga: 73,
          idCalidad: 2,
          cantidad: 30,
          precioUnitario: 4.50,
        ),
      );
      expect(api.path, '/detalle-carga/73/calidades');
      expect(api.body, {
        'id_calidad': 2,
        'cantidad': 30,
        'precio_unitario': 4.5,
      });
      expect(result.nombreCalidad, 'Segunda');
      await dataSource.addCalidadDetalle(
        const DetalleCargaCalidad(
          idDetalleCarga: 73,
          idCalidad: 1,
          cantidad: 10,
        ),
      );
      expect(api.body!.containsKey('precio_unitario'), isFalse);
      expect(api.body!.containsKey('id_variedad'), isFalse);
    },
  );

  test('Lee precios decimales serializados por Prisma como texto', () {
    final item = DetalleCargaCalidadModel.fromJson({
      'id_detalle_carga': '73',
      'id_calidad': '2',
      'cantidad': 40,
      'precio_unitario': '12.50',
    });
    expect(item.precioUnitario, 12.5);
  });

  test(
    'Excluye duplicadas e inactivas; guarda cantidad, empresa y precio con coma',
    () async {
      final repository = _Repository();
      final vm = _vm(repository);
      await vm.load(73);
      expect(vm.disponibles.map((item) => item.id), [2, 4]);
      expect(
        await vm.save(
          cantidadTotal: 100,
          idCalidad: 2,
          cantidad: '30',
          precio: '4,50',
        ),
        isTrue,
      );
      expect(repository.saved!.idDetalleCarga, 73);
      expect(repository.saved!.cantidad, 30);
      expect(repository.saved!.precioUnitario, 4.5);
      expect(repository.saved!.idEmpresa, 1);
      expect(vm.disponibles.map((item) => item.id), [4]);
      vm.dispose();
    },
  );

  for (final values in [
    (null, '10', ''),
    (2, '0', ''),
    (2, '1.5', ''),
    (2, '10', '-1'),
    (2, '10', 'abc'),
    (1, '10', ''),
  ]) {
    test('Valida datos inválidos o duplicados: $values', () async {
      final repository = _Repository();
      final vm = _vm(repository);
      await vm.load(73);
      expect(
        await vm.save(
          cantidadTotal: 100,
          idCalidad: values.$1,
          cantidad: values.$2,
          precio: values.$3,
        ),
        isFalse,
      );
      expect(repository.saved, isNull);
      expect(vm.errorMessage, isNotEmpty);
      expect(vm.isSaving, isFalse);
      vm.dispose();
    });
  }

  test(
    'Precio vacío se conserva como null y cero es un precio válido',
    () async {
      for (final input in ['', '0']) {
        final repository = _Repository();
        final vm = _vm(repository);
        await vm.load(73);
        expect(
          await vm.save(
            cantidadTotal: 100,
            idCalidad: 2,
            cantidad: '10',
            precio: input,
          ),
          isTrue,
        );
        expect(repository.saved!.precioUnitario, input.isEmpty ? null : 0);
        vm.dispose();
      }
    },
  );
}
