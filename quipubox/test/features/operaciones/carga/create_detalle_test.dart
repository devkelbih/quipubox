import 'package:quipubox/features/operaciones/carga/domain/entities/detalle_carga_calidad.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/update_detalle_operacion_carga.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quipubox/core/network/api_client.dart';
import 'package:quipubox/core/network/connectivity_viewmodel.dart';
import 'package:quipubox/core/network/network_checker.dart';
import 'package:quipubox/features/catalogos/frutas/domain/entities/fruta.dart';
import 'package:quipubox/features/catalogos/frutas/domain/repositories/fruta_repository.dart';
import 'package:quipubox/features/catalogos/frutas/domain/usecases/get_frutas.dart';
import 'package:quipubox/features/catalogos/variedades/domain/entities/variedad.dart';
import 'package:quipubox/features/catalogos/variedades/domain/repositories/variedad_repository.dart';
import 'package:quipubox/features/catalogos/variedades/domain/usecases/get_variedades.dart';
import 'package:quipubox/features/catalogos/tipos_jaba/domain/entities/tipos_jaba.dart';
import 'package:quipubox/features/catalogos/tipos_jaba/domain/enums/tipo_material_jaba.dart';
import 'package:quipubox/features/catalogos/tipos_jaba/domain/repositories/tipos_jaba_repository.dart';
import 'package:quipubox/features/catalogos/tipos_jaba/domain/usecases/get_tipos_jaba.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente_sede.dart';
import 'package:quipubox/features/organizacion/clientes/domain/enums/tipos_relacion_cliente_sedes.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente_puesto.dart';
import 'package:quipubox/features/organizacion/clientes/domain/enums/secciones_cliente_puesto.dart';
import 'package:quipubox/features/organizacion/clientes/domain/repositories/clientes_repository.dart';
import 'package:quipubox/features/organizacion/clientes/domain/usecases/get_clientes.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/detalle_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/asignacion_directa_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/create_detalle_operacion_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/usecases/get_operacion_carga_by_id.dart';
import 'package:quipubox/features/operaciones/carga/data/models/detalle_carga_request_model.dart';
import 'package:quipubox/features/operaciones/carga/data/models/detalle_carga_model.dart';
import 'package:quipubox/features/operaciones/carga/data/datasources/operacion_carga_remote_data_source.dart';
import 'package:quipubox/features/operaciones/carga/presentation/viewmodels/detalle_carga_form_viewmodel.dart';
import 'package:quipubox/features/operaciones/carga/presentation/screens/detalle_carga_form_screen.dart';

import 'carga_details_test.dart' as fixtures;

class _Repo extends fixtures.Repository {
  int updates = 0;
  @override
  Future<DetalleCarga> updateDetalle(DetalleCarga item) async {
    updates++;
    saved = item;
    return item;
  }

  @override
  Future<List<DetalleCargaCalidad>> getCalidadesDetalle(int id) async => [
    DetalleCargaCalidad(id: 1, idDetalleCarga: id, idCalidad: 1, cantidad: 20),
  ];
  String estado = 'pendiente';
  DetalleCarga? saved;
  AsignacionDirectaCarga? destino;
  int creates = 0;
  Completer<void>? pending;
  @override
  Future<OperacionCarga> getById(int id) async => OperacionCarga(
    id: id,
    idSedeOrigen: 1,
    idSedeDestino: 2,
    idCamion: 1,
    fechaCarga: DateTime(2026),
    estado: estado,
  );
  @override
  Future<DetalleCarga> createDetalle(
    int operacionId,
    DetalleCarga detalle, {
    AsignacionDirectaCarga? asignacionDirecta,
  }) async {
    creates++;
    if (pending != null) await pending!.future;
    saved = detalle;
    destino = asignacionDirecta;
    return detalle.copyWith(id: 73);
  }
}

class _Clientes implements ClienteRepository {
  @override
  Future<List<Cliente>> getAll() async => [
    const Cliente(
      id: 1,
      nombres: 'Emisor',
      sedes: [
        ClienteSede(idSede: 1, tipoRelacion: TipoRelacionClienteSede.emisor),
      ],
    ),
    Cliente(
      id: 2,
      nombres: 'Receptor',
      sedes: const [
        ClienteSede(idSede: 2, tipoRelacion: TipoRelacionClienteSede.receptor),
      ],
      puestos: [
        const ClientePuesto(idPuesto: 10, seccion: SeccionClientePuesto.a),
        const ClientePuesto(idPuesto: 11, estado: false),
        ClientePuesto(idPuesto: 12, fechaFin: DateTime(2026)),
      ],
    ),
    const Cliente(id: 3, nombres: 'Inactivo', estado: false),
  ];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Frutas implements FrutaRepository {
  @override
  Future<List<Fruta>> getAll() async => const [
    Fruta(id: 1, nombre: 'Pera'),
    Fruta(id: 2, nombre: 'Uva'),
  ];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Variedades implements VariedadRepository {
  @override
  Future<List<Variedad>> getAll() async => const [
    Variedad(id: 11, idFruta: 1, nombre: 'Variedad pera'),
    Variedad(id: 12, idFruta: 1, nombre: 'Inactiva', estado: false),
    Variedad(id: 21, idFruta: 2, nombre: 'Variedad uva'),
  ];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Tipos implements TipoJabaRepository {
  @override
  Future<List<TiposJaba>> getAll() async => const [
    TiposJaba(id: 1, nombre: 'Perera', tipoMaterial: TipoMaterialJaba.madera),
  ];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

CreateDetalleOperacionCargaUseCase _create(_Repo repo) =>
    CreateDetalleOperacionCargaUseCase(
      repository: repo,
      currentSession: fixtures.Session(),
    );

DetalleCargaFormViewModel _vm(_Repo repo) => DetalleCargaFormViewModel(
  getClientes: GetClientesUseCase(repository: _Clientes()),
  getFrutas: GetFrutasUseCase(repository: _Frutas()),
  getVariedades: GetVariedadesUseCase(repository: _Variedades()),
  getTiposJaba: GetTiposJabaUseCase(repository: _Tipos()),
  createDetalle: _create(repo),
  updateDetalle: UpdateDetalleOperacionCargaUseCase(
    repository: repo,
    currentSession: fixtures.Session(),
  ),
  getOperacion: GetOperacionCargaByIdUseCase(repository: repo),
);

DetalleCarga _detalle({
  bool reparto = true,
  int cantidad = 100,
  int? variedad,
}) => DetalleCarga(
  idClienteEmisor: 1,
  idFruta: 1,
  idVariedad: variedad,
  idTipoJaba: 1,
  cantidadJabas: cantidad,
  esReparto: reparto,
);

class _Api extends ApiClient {
  String? path;
  Map<String, dynamic>? body;
  @override
  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    this.path = path;
    this.body = body;
    return {'id_detalle_carga': 73, 'id_operacion': 44, ...?body};
  }
}

void main() {
  test(
    'Editar detalle precarga datos, valida clasificado y no crea otro registro',
    () async {
      final repo = _Repo();
      final vm = _vm(repo);
      final original = _detalle(cantidad: 30).copyWith(id: 73, idOperacion: 44);
      await vm.load(44, item: original);
      expect(vm.idEmisor, 1);
      expect(vm.esReparto, isTrue);
      expect(
        await vm.save(
          operacionId: 44,
          cantidad: '19',
          instrucciones: '',
          observaciones: '',
        ),
        isFalse,
      );
      expect(repo.updates, 0);
      expect(
        await vm.save(
          operacionId: 44,
          cantidad: '25',
          instrucciones: 'Cuidado',
          observaciones: '',
        ),
        isTrue,
      );
      expect(repo.creates, 0);
      expect(repo.updates, 1);
      expect(repo.saved!.id, 73);
      expect(repo.saved!.cantidadJabas, 25);
      expect(repo.saved!.idEmpresa, 1);
      vm.dispose();
    },
  );
  test(
    'Productores sin puestos se filtran por origen; receptores por destino',
    () async {
      final vm = _vm(_Repo());
      await vm.load(44);
      expect(vm.emisoresDisponibles.single.id, 1);
      expect(vm.emisoresDisponibles.single.puestos, isEmpty);
      vm.clientes.addAll(const [
        Cliente(
          id: 7,
          nombres: 'Productor de otra sede',
          sedes: [
            ClienteSede(
              idSede: 3,
              tipoRelacion: TipoRelacionClienteSede.emisor,
            ),
          ],
        ),
        Cliente(
          id: 8,
          nombres: 'Receptor de otra sede',
          sedes: [
            ClienteSede(
              idSede: 3,
              tipoRelacion: TipoRelacionClienteSede.receptor,
            ),
          ],
          puestos: [ClientePuesto(idPuesto: 30)],
        ),
        Cliente(
          id: 9,
          nombres: 'Receptor sin puesto',
          sedes: [
            ClienteSede(
              idSede: 2,
              tipoRelacion: TipoRelacionClienteSede.receptor,
            ),
          ],
        ),
        Cliente(
          id: 10,
          nombres: 'Emisor de destino',
          sedes: [
            ClienteSede(
              idSede: 2,
              tipoRelacion: TipoRelacionClienteSede.emisor,
            ),
          ],
        ),
      ]);
      expect(vm.emisoresDisponibles.map((item) => item.id), [1]);
      expect(vm.receptoresDisponibles.map((item) => item.id), [2, 9]);
      vm.selectReceptor(9);
      expect(vm.puestosDisponibles, isEmpty);
      vm.dispose();
    },
  );

  test(
    'Separa emisores y receptores por relación activa; admite ambos',
    () async {
      final vm = _vm(_Repo());
      await vm.load(44);
      expect(vm.esReparto, isFalse);
      expect(vm.emisoresDisponibles.map((item) => item.id), [1]);
      expect(vm.receptoresDisponibles.map((item) => item.id), [2]);
      vm.clientes.addAll([
        const Cliente(
          id: 4,
          nombres: 'Ambos',
          sedes: [
            ClienteSede(idSede: 1, tipoRelacion: TipoRelacionClienteSede.ambos),
            ClienteSede(idSede: 2, tipoRelacion: TipoRelacionClienteSede.ambos),
          ],
          puestos: [ClientePuesto(idPuesto: 20)],
        ),
        const Cliente(
          id: 5,
          nombres: 'Emisor con puesto',
          sedes: [
            ClienteSede(
              idSede: 1,
              tipoRelacion: TipoRelacionClienteSede.emisor,
            ),
          ],
          puestos: [ClientePuesto(idPuesto: 21)],
        ),
        const Cliente(
          id: 6,
          nombres: 'Relación inactiva',
          sedes: [
            ClienteSede(
              idSede: 1,
              tipoRelacion: TipoRelacionClienteSede.ambos,
              estado: false,
            ),
          ],
          puestos: [ClientePuesto(idPuesto: 22)],
        ),
      ]);
      expect(vm.emisoresDisponibles.map((item) => item.id), [1, 4, 5]);
      expect(vm.receptoresDisponibles.map((item) => item.id), [2, 4]);
      vm.dispose();
    },
  );

  test(
    'Un emisor puede registrar varios envíos al mismo o a distintos receptores',
    () async {
      final repo = _Repo();
      final vm = _vm(repo);
      await vm.load(44);
      vm.updateSelection(emisor: 1, tipoJaba: 1);
      vm.selectFruta(1);
      vm.selectReceptor(2);
      vm.selectPuesto(vm.puestosDisponibles.single);
      for (var index = 0; index < 2; index++) {
        expect(
          await vm.save(
            operacionId: 44,
            cantidad: '10',
            instrucciones: '',
            observaciones: '',
          ),
          isTrue,
        );
      }
      vm.clientes.add(
        const Cliente(
          id: 4,
          nombres: 'Otro receptor',
          sedes: [
            ClienteSede(
              idSede: 2,
              tipoRelacion: TipoRelacionClienteSede.receptor,
            ),
          ],
          puestos: [ClientePuesto(idPuesto: 20)],
        ),
      );
      vm.selectReceptor(4);
      vm.selectPuesto(vm.puestosDisponibles.single);
      expect(
        await vm.save(
          operacionId: 44,
          cantidad: '15',
          instrucciones: '',
          observaciones: '',
        ),
        isTrue,
      );
      expect(repo.creates, 3);
      expect(repo.saved!.idClienteEmisor, 1);
      expect(repo.destino!.idClienteReceptor, 4);
      vm.dispose();
    },
  );

  test(
    'Carga para reparto: contrato de creación sin datos de destinatarios',
    () async {
      final api = _Api();
      final request = DetalleCargaRequestModel.fromEntity(_detalle());
      final saved = await OperacionCargaRemoteDataSource(
        apiClient: api,
      ).createDetalle(44, request);
      expect(api.path, '/operaciones-carga/44/detalles');
      expect(saved.id, 73);
      expect(api.body!['es_reparto'], isTrue);
      for (final field in [
        'id_cliente_receptor',
        'id_puesto',
        'id_seccion',
        'id_variedad',
      ]) {
        expect(api.body!.containsKey(field), isFalse);
      }
    },
  );

  test(
    'Asignación directa va separada de la entidad y conserva el DTO actual',
    () {
      final request = DetalleCargaRequestModel.fromEntity(
        _detalle(reparto: false),
        asignacionDirecta: const AsignacionDirectaCarga(
          idClienteReceptor: 2,
          idPuesto: 10,
          seccion: 'A',
        ),
      );
      expect(request.toCreateJson()['id_cliente_receptor'], 2);
      expect(request.toCreateJson()['id_puesto'], 10);
      expect(request.toCreateJson()['id_seccion'], 'A');
    },
  );

  test(
    'Mercadería leída no se contamina con asignaciones de items_reparto',
    () {
      final model = DetalleCargaModel.fromJson({
        'id_detalle_carga': 73,
        'id_cliente_emisor': 1,
        'id_fruta': 1,
        'id_tipo_jaba': 1,
        'cantidad_jabas': 100,
        'es_reparto': true,
        'items_reparto': [
          {
            'clientes': {'nombres': 'Pedro'},
          },
        ],
      });
      expect(model.toEntity().cantidadJabas, 100);
      expect(model.toJson().containsKey('items_reparto'), isFalse);
      expect(model.toJson().containsKey('id_cliente_receptor'), isFalse);
    },
  );

  test(
    'Filtra variedades por fruta y reinicia selecciones dependientes',
    () async {
      final vm = _vm(_Repo());
      await vm.load(44);
      expect(vm.clientes.map((item) => item.id), [1, 2]);
      vm.selectFruta(1);
      vm.selectVariedad(11);
      expect(vm.variedadesDisponibles.map((item) => item.id), [11]);
      vm.selectFruta(2);
      expect(vm.idVariedad, isNull);
      expect(vm.variedadesDisponibles.map((item) => item.id), [21]);
      vm.setReparto(false);
      vm.selectReceptor(2);
      expect(vm.puestosDisponibles.map((item) => item.idPuesto), [10]);
      vm.selectPuesto(vm.puestosDisponibles.single);
      vm.setReparto(true);
      expect(vm.idReceptor, isNull);
      expect(vm.puestoDirecto, isNull);
      vm.dispose();
    },
  );

  test('Guarda empresa y operación desde el caso de uso', () async {
    final repo = _Repo();
    await _create(repo)(operacionId: 44, detalle: _detalle());
    expect(repo.saved!.idEmpresa, 1);
    expect(repo.saved!.idOperacion, 44);
    expect(repo.destino, isNull);
  });

  test(
    'Rechaza cantidad inválida, variedad ajena y destino contradictorio',
    () async {
      final repo = _Repo();
      final create = _create(repo);
      await expectLater(
        create(operacionId: 44, detalle: _detalle(cantidad: 0)),
        throwsException,
      );
      await expectLater(
        create(
          operacionId: 44,
          detalle: _detalle(variedad: 21),
          variedad: const Variedad(id: 21, idFruta: 2, nombre: 'Uva'),
        ),
        throwsException,
      );
      await expectLater(
        create(
          operacionId: 44,
          detalle: _detalle(),
          asignacionDirecta: const AsignacionDirectaCarga(
            idClienteReceptor: 2,
            idPuesto: 10,
          ),
        ),
        throwsException,
      );
      await expectLater(
        create(operacionId: 44, detalle: _detalle(reparto: false)),
        throwsException,
      );
      expect(repo.creates, 0);
    },
  );

  test('Comprueba el estado actual antes de registrar', () async {
    final repo = _Repo()..estado = 'repartiendo';
    await expectLater(
      _create(repo)(operacionId: 44, detalle: _detalle()),
      throwsException,
    );
    expect(repo.creates, 0);
  });

  test(
    'Entrega directa toma receptor, puesto y sección de la relación activa',
    () async {
      final repo = _Repo();
      final vm = _vm(repo);
      await vm.load(44);
      vm.updateSelection(emisor: 1, tipoJaba: 1);
      vm.selectFruta(1);
      vm.setReparto(false);
      vm.selectReceptor(2);
      vm.selectPuesto(vm.puestosDisponibles.single);
      expect(
        await vm.save(
          operacionId: 44,
          cantidad: '100',
          instrucciones: '',
          observaciones: '',
        ),
        isTrue,
      );
      expect(repo.saved!.esReparto, isFalse);
      expect(repo.destino!.idClienteReceptor, 2);
      expect(repo.destino!.idPuesto, 10);
      expect(repo.destino!.seccion, 'A');
      vm.dispose();
    },
  );

  test('Bloquea doble guardado y expone errores para el toast', () async {
    final repo = _Repo()..pending = Completer();
    final vm = _vm(repo);
    await vm.load(44);
    vm.updateSelection(emisor: 1, tipoJaba: 1);
    vm.selectFruta(1);
    vm.setReparto(true);
    final pending = vm.save(
      operacionId: 44,
      cantidad: '10',
      instrucciones: '',
      observaciones: '',
    );
    expect(
      await vm.save(
        operacionId: 44,
        cantidad: '10',
        instrucciones: '',
        observaciones: '',
      ),
      isFalse,
    );
    repo.pending!.complete();
    expect(await pending, isTrue);
    expect(repo.creates, 1);
    expect(
      await vm.save(
        operacionId: 44,
        cantidad: '0',
        instrucciones: '',
        observaciones: '',
      ),
      isFalse,
    );
    expect(vm.errorMessage, isNotNull);
    expect(vm.isSaving, isFalse);
    vm.dispose();
  });

  testWidgets(
    'Formulario registra carga para reparto sin pedir destinatarios',
    (tester) async {
      final repo = _Repo();
      final vm = _vm(repo);
      final connectivity = ConnectivityViewModel(
        networkChecker: NetworkChecker(),
      );
      bool? result;
      await tester.pumpWidget(
        ChangeNotifierProvider<ConnectivityViewModel>.value(
          value: connectivity,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: FilledButton(
                  onPressed: () async {
                    result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) =>
                            ChangeNotifierProvider<
                              DetalleCargaFormViewModel
                            >.value(
                              value: vm,
                              child: const DetalleCargaFormScreen(
                                operacionId: 44,
                              ),
                            ),
                      ),
                    );
                  },
                  child: const Text('Abrir'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();
      expect(vm.esReparto, isFalse);
      Future<void> select(String label, String value) async {
        await tester.tap(
          find.widgetWithText(DropdownButtonFormField<int>, label),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text(value).last);
        await tester.pumpAndSettle();
      }

      await select('Cliente emisor', 'Emisor');
      await select('Fruta', 'Pera');
      await select('Tipo de jaba', 'Perera');
      await tester.enterText(
        find.widgetWithText(TextField, 'Cantidad de jabas'),
        '100',
      );
      final reparto = find.widgetWithText(
        SwitchListTile,
        'Distribuir después (reparto)',
      );
      await tester.scrollUntilVisible(
        reparto,
        150,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(reparto);
      await tester.pumpAndSettle();
      expect(vm.esReparto, isTrue);
      expect(find.text('Receptor de entrega directa'), findsNothing);
      final save = find.widgetWithText(FilledButton, 'Registrar detalle');
      await tester.scrollUntilVisible(
        save,
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(result, isTrue);
      expect(repo.saved!.cantidadJabas, 100);
      expect(repo.saved!.esReparto, isTrue);
      expect(repo.destino, isNull);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      vm.dispose();
      connectivity.dispose();
    },
  );
}
