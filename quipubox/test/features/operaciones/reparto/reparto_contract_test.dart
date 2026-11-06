import 'package:flutter_test/flutter_test.dart';
import 'package:quipubox/core/network/api_client.dart';
import 'package:quipubox/features/operaciones/reparto/data/datasources/reparto_remote_data_source.dart';
import 'package:quipubox/features/operaciones/reparto/data/repositories/reparto_repository_impl.dart';
import 'package:quipubox/features/operaciones/reparto/domain/entities/reparto.dart';
import 'reparto_fixtures.dart' as f;

Map<String, dynamic> get lineJson => {
  'id_item_reparto_detalle': '11',
  'id_detalle_carga_calidad': '101',
  'cantidad': 20,
  'precio_unitario': '7.25',
  'detalle_carga_calidades': {
    'calidades': {'nombre': 'Primera'},
  },
};
Map<String, dynamic> get itemJson => {
  'id_item_reparto': '1',
  'id_detalle_carga': '73',
  'id_cliente_receptor': '25',
  'id_puesto': '221',
  'cantidad_asignada': 30,
  'seccion': 'A',
  'detalle_carga': {'id_operacion': '44'},
  'items_reparto_detalle': [lineJson],
  'entregas': [],
  'guia_asociada': null,
};

class Api extends ApiClient {
  final calls =
      <
        ({
          String method,
          String path,
          Map<String, dynamic>? body,
          Map<String, String>? query,
          bool nulls,
        })
      >[];
  @override
  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    calls.add((
      method: 'GET',
      path: path,
      body: null,
      query: query,
      nulls: false,
    ));
    if (path == '/items-reparto/1') return itemJson;
    if (path == '/items-reparto/detalle/11') return lineJson;
    if (path.endsWith('/detalle')) return [lineJson];
    return [itemJson];
  }

  @override
  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    calls.add((
      method: 'POST',
      path: path,
      body: body,
      query: null,
      nulls: false,
    ));
    return itemJson;
  }

  @override
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    bool preserveNulls = false,
  }) async {
    calls.add((
      method: 'PUT',
      path: path,
      body: body,
      query: null,
      nulls: preserveNulls,
    ));
    return itemJson;
  }

  @override
  Future<dynamic> delete(String path) async {
    calls.add((
      method: 'DELETE',
      path: path,
      body: null,
      query: null,
      nulls: false,
    ));
    return {};
  }
}

void main() {
  late Api api;
  late RepartoRepositoryImpl repo;
  setUp(() {
    api = Api();
    repo = RepartoRepositoryImpl(RepartoRemoteDataSource(api));
  });
  test(
    'Listado y detalle leen IDs, operación, desglose y precios decimales',
    () async {
      final rows = await repo.getAll(
        detalleId: 73,
        receptorId: 25,
        puestoId: 221,
        seccion: 'A',
      );
      expect(api.calls.single.query, {
        'id_detalle_carga': '73',
        'id_cliente_receptor': '25',
        'id_puesto': '221',
        'seccion': 'A',
      });
      expect(rows.single.operacionId, 44);
      expect(rows.single.cantidadDesglosada, 20);
      expect(rows.single.lineas.single.precio, 7.25);
      expect((await repo.getById(1)).id, 1);
      expect((await repo.getByDetalle(73)).single.detalleId, 73);
      expect((await repo.getLineas(1)).single.nombre, 'Primera');
      expect((await repo.getLinea(11)).idCalidadCarga, 101);
    },
  );
  test(
    'Los tres contratos de creación envían únicamente los campos admitidos',
    () async {
      await repo.createSimple(73, f.asignacion(lineas: []));
      expect(api.calls.last.path, '/items-reparto');
      expect(api.calls.last.body!['cantidad_asignada'], 30);
      expect(api.calls.last.body!.containsKey('detalles'), isFalse);
      await repo.createConCalidades(73, f.asignacion());
      expect(api.calls.last.path, '/items-reparto/from-calidades');
      expect(api.calls.last.body!['detalles'], [
        {'id_detalle_carga_calidad': 101, 'cantidad': 20},
        {'id_detalle_carga_calidad': 102, 'cantidad': 10},
      ]);
      expect(api.calls.last.body!.containsKey('cantidad_asignada'), isFalse);
      await repo.createMultiple(73, [f.asignacion(), f.asignacion()]);
      expect(api.calls.last.path, '/items-reparto/from-calidades-multiple');
      expect(api.calls.last.body!['asignaciones'], hasLength(2));
    },
  );
  test(
    'Actualizaciones usan IDs correctos y permiten limpiar campos opcionales',
    () async {
      await repo.update(1, 73, f.asignacion(lineas: []));
      expect(api.calls.last.path, '/items-reparto/1');
      expect(api.calls.last.body!['id_detalle_carga'], 73);
      expect(api.calls.last.nulls, isTrue);
      await repo.addLinea(
        1,
        const RepartoLinea(idCalidadCarga: 101, cantidad: 5),
      );
      expect(api.calls.last.path, '/items-reparto/1/detalle');
      await repo.updateLinea(
        11,
        const RepartoLinea(id: 11, idCalidadCarga: 101, cantidad: 6),
      );
      expect(api.calls.last.path, '/items-reparto/detalle/11');
      expect(api.calls.last.body, {'cantidad': 6, 'precio_unitario': null});
      expect(api.calls.last.nulls, isTrue);
      await repo.deleteLinea(11);
      expect(api.calls.last.path, '/items-reparto/detalle/11');
      await repo.delete(1);
      expect(api.calls.last.path, '/items-reparto/1');
    },
  );
}
