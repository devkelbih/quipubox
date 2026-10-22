import 'package:flutter_test/flutter_test.dart';
import 'package:quipubox/core/network/api_client.dart';
import 'package:quipubox/features/organizacion/clientes/data/datasources/clientes_remote_data_source.dart';
import 'package:quipubox/features/organizacion/clientes/data/models/cliente_model.dart';
import 'package:quipubox/features/organizacion/clientes/data/repositories/clientes_repository_impl.dart';

Map<String, dynamic> fixture({
  bool nested = true,
  bool sede = true,
  int lugarId = 5,
}) => {
  'id_cliente': 7,
  'id_empresa': 1,
  'nombres': 'Juan',
  'estado': true,
  'cliente_sede': [
    {
      'id_cliente_sede': 10,
      'id_cliente': 7,
      'id_empresa': 1,
      'id_sede': 2,
      'tipo_relacion': 'emisor',
      'estado': true,
      if (sede)
        'sedes': {
          'id_sede': 2,
          'id_empresa': 1,
          'nombre': 'Sede Cañete',
          'tipo_sede': 'origen',
          'estado': true,
        },
    },
  ],
  'clientes_puestos': [
    {
      'id_cliente_puesto': 20,
      'id_cliente': 7,
      'id_empresa': 1,
      'id_puesto': 380,
      'estado': true,
      'puestos': {
        'id_puesto': 380,
        'id_empresa': 1,
        'id_lugar': lugarId,
        'numero_puesto': 'A-12',
        'estado': true,
        if (nested)
          'lugares_operativos': {
            'id_lugar': lugarId,
            'id_empresa': 1,
            'id_sede': 2,
            'nombre': 'Mercado Central',
            'tipo_lugar': 'mercado',
            'estado': true,
          },
      },
    },
  ],
};

class StubApiClient extends ApiClient {
  final Map<String, dynamic> response;
  final calls = <String>[];
  StubApiClient(this.response);

  @override
  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    calls.add('POST $path');
    expect((body!['puestos'] as List).single, isNot(contains('puestos')));
    return response;
  }

  @override
  Future<dynamic> put(String path, {Map<String, dynamic>? body}) async {
    calls.add('PUT $path');
    return response;
  }
}

void main() {
  for (final creating in [true, false]) {
    test(
      'Guardar: crear=$creating conserva lugar y sede cuando la respuesta es parcial',
      () async {
        final submitted = ClienteModel.fromJson(fixture()).toEntity();
        final response = fixture(nested: false, sede: false);
        response['nombres'] = 'Nombre confirmado';
        final api = StubApiClient(response);
        final repository = ClienteRepositoryImpl(
          remoteDataSource: ClienteRemoteDataSource(apiClient: api),
        );
        final result = creating
            ? await repository.create(submitted)
            : await repository.update(submitted);
        expect(result.nombres, 'Nombre confirmado');
        expect(
          result.puestos.single.puesto!.lugarOperativo!.nombre,
          'Mercado Central',
        );
        expect(result.puestos.single.puesto!.numeroPuesto, 'A-12');
        expect(result.sedes.single.sede!.nombre, 'Sede Cañete');
        expect(result.puestos.single.id, 20);
        expect(api.calls, [
          creating ? 'POST /clientes/full' : 'PUT /clientes/7/full',
        ]);
      },
    );

    test(
      'Guardar: crear=$creating respeta datos y relaciones confirmadas por la API',
      () async {
        final submitted = ClienteModel.fromJson(fixture()).toEntity();
        final response = fixture();
        final relation = (response['clientes_puestos'] as List).single as Map;
        final puesto = relation['puestos'] as Map;
        puesto['numero_puesto'] = 'B-99';
        (puesto['lugares_operativos'] as Map)['nombre'] = 'Lugar actualizado';
        ((response['cliente_sede'] as List).single['sedes'] as Map)['nombre'] =
            'Sede actualizada';
        final repository = ClienteRepositoryImpl(
          remoteDataSource: ClienteRemoteDataSource(
            apiClient: StubApiClient(response),
          ),
        );
        final result = creating
            ? await repository.create(submitted)
            : await repository.update(submitted);
        expect(result.puestos.single.puesto!.numeroPuesto, 'B-99');
        expect(
          result.puestos.single.puesto!.lugarOperativo!.nombre,
          'Lugar actualizado',
        );
        expect(result.sedes.single.sede!.nombre, 'Sede actualizada');
      },
    );
  }

  test(
    'Actualizar no asocia un lugar anterior si cambió la FK del puesto',
    () async {
      final repository = ClienteRepositoryImpl(
        remoteDataSource: ClienteRemoteDataSource(
          apiClient: StubApiClient(fixture(nested: false, lugarId: 9)),
        ),
      );
      final result = await repository.update(
        ClienteModel.fromJson(fixture()).toEntity(),
      );
      expect(result.puestos.single.puesto!.idLugar, 9);
      expect(result.puestos.single.puesto!.lugarOperativo, isNull);
    },
  );

  test(
    'Actualizar no recupera relaciones eliminadas por el servidor',
    () async {
      final response = fixture();
      response['clientes_puestos'] = [];
      response['cliente_sede'] = [];
      final repository = ClienteRepositoryImpl(
        remoteDataSource: ClienteRemoteDataSource(
          apiClient: StubApiClient(response),
        ),
      );
      final result = await repository.update(
        ClienteModel.fromJson(fixture()).toEntity(),
      );
      expect(result.puestos, isEmpty);
      expect(result.sedes, isEmpty);
    },
  );

  test(
    'Actualizar conserva el puesto del formulario si la respuesta solo trae su ID',
    () async {
      final response = fixture(sede: false);
      ((response['clientes_puestos'] as List).single as Map).remove('puestos');
      final repository = ClienteRepositoryImpl(
        remoteDataSource: ClienteRemoteDataSource(
          apiClient: StubApiClient(response),
        ),
      );
      final result = await repository.update(
        ClienteModel.fromJson(fixture()).toEntity(),
      );
      expect(result.puestos.single.puesto!.numeroPuesto, 'A-12');
      expect(
        result.puestos.single.puesto!.lugarOperativo!.nombre,
        'Mercado Central',
      );
      expect(result.sedes.single.sede!.nombre, 'Sede Cañete');
    },
  );
}
