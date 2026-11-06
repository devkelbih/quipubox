import 'package:flutter_test/flutter_test.dart';
import 'package:quipubox/core/network/api_client.dart';
import 'package:quipubox/features/operaciones/carga/data/datasources/operacion_carga_remote_data_source.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/detalle_carga.dart';
import 'package:quipubox/features/operaciones/carga/domain/entities/detalle_carga_calidad.dart';

class _Api extends ApiClient {
  String? path;
  Map<String, dynamic>? body;
  bool keepsNulls = false;
  @override
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    bool preserveNulls = false,
  }) async {
    this.path = path;
    this.body = body;
    keepsNulls = preserveNulls;
    if (path.contains('/calidades/')) {
      return {
        'id_detalle_carga_calidad': 101,
        'id_detalle_carga': 73,
        'id_calidad': 1,
        ...?body,
      };
    }
    return {'id_detalle_carga': 73, 'id_operacion': 44, ...?body};
  }
}

void main() {
  test(
    'PUT calidad usa el ID del registro y permite borrar precio sin cambiar tipo',
    () async {
      final api = _Api();
      final remote = OperacionCargaRemoteDataSource(apiClient: api);
      final result = await remote.updateCalidadDetalle(
        const DetalleCargaCalidad(
          id: 101,
          idDetalleCarga: 73,
          idCalidad: 1,
          cantidad: 40,
        ),
      );
      expect(api.path, '/detalle-carga/calidades/101');
      expect(api.body, {'cantidad': 40, 'precio_unitario': null});
      expect(api.keepsNulls, isTrue);
      expect(result.precioUnitario, isNull);
    },
  );

  test(
    'PUT detalle conserva asignación y permite limpiar variedad y observaciones',
    () async {
      final api = _Api();
      final remote = OperacionCargaRemoteDataSource(apiClient: api);
      final result = await remote.updateDetalle(
        const DetalleCarga(
          id: 73,
          idOperacion: 44,
          idClienteEmisor: 1,
          idFruta: 2,
          idTipoJaba: 3,
          cantidadJabas: 50,
        ),
      );
      expect(api.path, '/detalle-carga/73');
      expect(api.body!['cantidad_jabas'], 50);
      expect(api.body!.containsKey('observaciones'), isTrue);
      expect(api.body!['observaciones'], isNull);
      expect(api.body!.containsKey('es_reparto'), isFalse);
      expect(api.body!.containsKey('id_cliente_receptor'), isFalse);
      expect(api.keepsNulls, isTrue);
      expect(result.cantidadJabas, 50);
    },
  );
}
