import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/core/network/api_client.dart';
import 'package:quipubox/core/session/current_session.dart';
import 'package:quipubox/features/organizacion/clientes/data/datasources/clientes_remote_data_source.dart';
import 'package:quipubox/features/organizacion/clientes/data/repositories/clientes_repository_impl.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente_page.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente_sede.dart';
import 'package:quipubox/features/organizacion/clientes/domain/enums/tipos_relacion_cliente_sedes.dart';
import 'package:quipubox/features/organizacion/clientes/domain/repositories/clientes_repository.dart';
import 'package:quipubox/features/organizacion/clientes/domain/usecases/get_clientes_page.dart';
import 'package:quipubox/features/organizacion/clientes/domain/usecases/create_cliente.dart';
import 'package:quipubox/features/organizacion/clientes/domain/usecases/update_cliente.dart';
import 'package:quipubox/features/organizacion/clientes/domain/usecases/change_cliente_estado.dart';
import 'package:quipubox/features/organizacion/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:quipubox/features/organizacion/clientes/presentation/widgets/clientes_pagination_bar.dart';

class _Session implements CurrentSession {
  @override
  int get currentCompanyId => 1;
  @override
  int get currentUserId => 1;
  @override
  int get currentSedeId => 1;
}

Cliente _cliente(int id) => Cliente(
  id: id,
  nombres: id == 21 ? 'Especial' : 'Cliente $id',
  estado: id <= 16,
  sedes: const [
    ClienteSede(idSede: 1, tipoRelacion: TipoRelacionClienteSede.emisor),
  ],
);

class _Repository implements ClienteRepository {
  final records = List.generate(21, (index) => _cliente(index + 1));
  final queries = <(int, int, String, bool?)>[];
  final relations = <String?>[];
  int allCalls = 0;
  bool delayNext = false;
  bool failNext = false;
  Completer<ClientePage>? deferred;
  ClientePage? heldPage;

  @override
  Future<List<Cliente>> getAll() async {
    allCalls++;
    return records;
  }

  @override
  Future<ClientePage> getPage({
    int page = 1,
    int limit = 10,
    String buscar = '',
    bool? estado,
    String? tipoRelacion,
  }) {
    queries.add((page, limit, buscar, estado));
    relations.add(tipoRelacion);
    final matching = records
        .where(
          (item) =>
              (estado == null || item.estado == estado) &&
              item.nombreCompleto.toLowerCase().contains(buscar.toLowerCase()),
        )
        .toList();
    final result = ClientePage(
      items: matching.skip((page - 1) * limit).take(limit).toList(),
      total: matching.length,
      page: page,
      limit: limit,
      totalPages: (matching.length / limit).ceil(),
    );
    if (limit == 10 && failNext) {
      failNext = false;
      return Future.error(const AppException('Falló la consulta.'));
    }
    if (limit == 10 && delayNext) {
      delayNext = false;
      heldPage = result;
      deferred = Completer();
      return deferred!.future;
    }
    return Future.value(result);
  }

  @override
  Future<Cliente> create(Cliente cliente) async {
    final created = cliente.copyWith(id: records.last.id! + 1);
    records.add(created);
    return created;
  }

  @override
  Future<Cliente> update(Cliente cliente) async {
    records[records.indexWhere((item) => item.id == cliente.id)] = cliente;
    return cliente;
  }

  @override
  Future<bool> changeStatus({required int id, required bool estado}) async {
    final index = records.indexWhere((item) => item.id == id);
    records[index] = records[index].copyWith(estado: estado);
    return estado;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ClienteViewModel _vm(_Repository repo) => ClienteViewModel(
  getPageUseCase: GetClientesPageUseCase(repository: repo),
  createUseCase: CreateClienteUseCase(
    repository: repo,
    currentSession: _Session(),
  ),
  updateUseCase: UpdateClienteUseCase(repository: repo),
  changeStatusUseCase: ChangeClienteEstadoUseCase(repository: repo),
);

class _Api extends ApiClient {
  final calls = <(String, Map<String, String>?)>[];
  @override
  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    calls.add((path, query));
    final clientes = List.generate(
      21,
      (index) => {
        'id_cliente': index + 1,
        'id_empresa': 1,
        'nombres': 'Cliente ${index + 1}',
        'estado': true,
      },
    );
    if (path == '/clientes/all') return clientes;
    final page = int.parse(query!['page']!);
    final limit = int.parse(query['limit']!);
    return {
      'data': clientes.skip((page - 1) * limit).take(limit).toList(),
      'total': 21,
      'page': page,
      'limit': limit,
      'totalPages': (21 / limit).ceil(),
    };
  }
}

void main() {
  test(
    'Relación se conserva en páginas y contadores sin usar clientes/all',
    () async {
      final repo = _Repository();
      final vm = _vm(repo);
      await vm.setFilters(buscar: '', estado: null, tipoRelacion: 'receptor');
      await vm.load(page: 2);
      expect(repo.relations, everyElement('receptor'));
      expect(repo.allCalls, 0);
      vm.dispose();
    },
  );

  test('Datasource envía tipo_relacion en la consulta paginada', () async {
    final api = _Api();
    final repo = ClienteRepositoryImpl(
      remoteDataSource: ClienteRemoteDataSource(apiClient: api),
    );
    await repo.getPage(tipoRelacion: 'emisor');
    expect(api.calls.single.$1, '/clientes');
    expect(api.calls.single.$2?['tipo_relacion'], 'emisor');
    expect(api.calls.single.$2?.containsKey('id_sede'), isFalse);
  });
  test(
    'El repositorio conserva metadatos y separa /clientes/all de /clientes',
    () async {
      final api = _Api();
      final repo = ClienteRepositoryImpl(
        remoteDataSource: ClienteRemoteDataSource(apiClient: api),
      );
      final result = await repo.getPage(page: 2, buscar: ' Ana ', estado: true);
      expect(result.page, 2);
      expect(result.limit, 10);
      expect(result.total, 21);
      expect(result.totalPages, 3);
      expect(result.items.first.id, 11);
      expect(result.items.length, 10);
      expect(api.calls.first.$1, '/clientes');
      expect(api.calls.first.$2, {
        'page': '2',
        'limit': '10',
        'estado': 'true',
        'buscar': 'Ana',
      });
      final all = await repo.getAll();
      expect(all.length, 21);
      expect(api.calls.last.$1, '/clientes/all');
    },
  );

  test(
    'Primera página y contadores usan el total del servidor, no sus diez filas',
    () async {
      final repo = _Repository();
      final vm = _vm(repo);
      await vm.load();
      expect(vm.items.length, 10);
      expect(vm.total, 21);
      expect(vm.totalPages, 3);
      expect(vm.activeCount, 16);
      expect(vm.inactiveCount, 5);
      expect(vm.totalCount, 21);
      expect(repo.allCalls, 0);
      vm.dispose();
    },
  );

  test(
    'Navega y busca un cliente que estaba fuera de la primera página',
    () async {
      final vm = _vm(_Repository());
      await vm.load();
      await vm.load(page: 2);
      expect(vm.currentPage, 2);
      expect(vm.items.first.id, 11);
      await vm.setFilters(buscar: 'Especial', estado: null);
      expect(vm.currentPage, 1);
      expect(vm.items.single.id, 21);
      expect(vm.total, 1);
      expect(vm.activeCount, 0);
      expect(vm.inactiveCount, 1);
      vm.dispose();
    },
  );

  test(
    'El filtro de estado se aplica antes de paginar y reinicia la página',
    () async {
      final vm = _vm(_Repository());
      await vm.setFilters(buscar: '', estado: true);
      await vm.load(page: 2);
      expect(vm.items.length, 6);
      expect(vm.total, 16);
      await vm.setFilters(buscar: '', estado: false);
      expect(vm.currentPage, 1);
      expect(vm.items.length, 5);
      expect(vm.total, 5);
      expect(vm.items.every((item) => !item.estado), isTrue);
      expect(vm.totalCount, 21);
      vm.dispose();
    },
  );

  test(
    'Una búsqueda nueva durante la carga sustituye los resultados atrasados',
    () async {
      final repo = _Repository()..delayNext = true;
      final vm = _vm(repo);
      final pending = vm.load();
      await vm.setFilters(buscar: 'Especial', estado: null);
      repo.deferred!.complete(repo.heldPage!);
      await pending;
      expect(vm.items.single.id, 21);
      expect(vm.total, 1);
      expect(vm.isLoading, isFalse);
      expect(vm.errorMessage, isNull);
      vm.dispose();
    },
  );

  test('El error conserva la página anterior y permite reintentar', () async {
    final repo = _Repository();
    final vm = _vm(repo);
    await vm.load();
    repo.failNext = true;
    await vm.load(page: 2);
    expect(vm.currentPage, 1);
    expect(vm.items.first.id, 1);
    expect(vm.errorMessage, isNotNull);
    await vm.load(page: 2);
    expect(vm.currentPage, 2);
    expect(vm.errorMessage, isNull);
    vm.dispose();
  });

  test(
    'Si desaparece la última página, vuelve a la última página válida',
    () async {
      final repo = _Repository();
      final vm = _vm(repo);
      await vm.load(page: 3);
      expect(vm.items.single.id, 21);
      repo.records.removeLast();
      await vm.load();
      expect(vm.currentPage, 2);
      expect(vm.totalPages, 2);
      expect(vm.total, 20);
      vm.dispose();
    },
  );

  test(
    'Cambiar estado refresca filas y contadores del filtro actual',
    () async {
      final vm = _vm(_Repository());
      await vm.setFilters(buscar: '', estado: true);
      expect(await vm.changeStatus(id: 1, estado: false), isTrue);
      expect(vm.items.any((item) => item.id == 1), isFalse);
      expect(vm.activeCount, 15);
      expect(vm.inactiveCount, 6);
      expect(vm.total, 15);
      vm.dispose();
    },
  );

  test('Crear y editar recarga la página con los filtros vigentes', () async {
    final vm = _vm(_Repository());
    await vm.load();
    expect(await vm.create(_cliente(22).copyWith(nombres: 'Nuevo')), isTrue);
    expect(vm.total, 22);
    await vm.setFilters(buscar: 'Nuevo', estado: null);
    expect(vm.items.single.nombreCompleto, 'Nuevo');
    expect(
      await vm.update(vm.items.single.copyWith(nombres: 'Editado')),
      isTrue,
    );
    expect(vm.items, isEmpty);
    expect(vm.total, 0);
    vm.dispose();
  });

  testWidgets('Controles de paginación respetan límites y carga', (
    tester,
  ) async {
    final pages = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClientesPaginationBar(
            page: 2,
            totalPages: 3,
            total: 21,
            busy: false,
            onPage: pages.add,
          ),
        ),
      ),
    );
    expect(find.text('Página 2 de 3 · 21 clientes'), findsOneWidget);
    await tester.tap(find.byTooltip('Página anterior'));
    await tester.tap(find.byTooltip('Página siguiente'));
    expect(pages, [1, 3]);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClientesPaginationBar(
            page: 1,
            totalPages: 1,
            total: 5,
            busy: false,
            onPage: pages.add,
          ),
        ),
      ),
    );
    expect(
      tester
          .widget<IconButton>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is IconButton && widget.tooltip == 'Página anterior',
            ),
          )
          .onPressed,
      isNull,
    );
    expect(
      tester
          .widget<IconButton>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is IconButton && widget.tooltip == 'Página siguiente',
            ),
          )
          .onPressed,
      isNull,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClientesPaginationBar(
            page: 2,
            totalPages: 3,
            total: 21,
            busy: true,
            onPage: pages.add,
          ),
        ),
      ),
    );
    expect(
      tester
          .widget<IconButton>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is IconButton && widget.tooltip == 'Página siguiente',
            ),
          )
          .onPressed,
      isNull,
    );
  });
}
