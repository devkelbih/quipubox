import '../../domain/entities/detalle_carga.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/response_parser.dart';
import '../models/detalle_carga_model.dart';
import '../models/detalle_carga_calidad_model.dart';
import '../../domain/entities/detalle_carga_calidad.dart';
import '../models/detalle_carga_request_model.dart';
import '../models/guia_operacion_carga_model.dart';
import '../models/operacion_carga_model.dart';
import '../models/operacion_carga_request_model.dart';

class OperacionCargaRemoteDataSource {
  final ApiClient apiClient;

  const OperacionCargaRemoteDataSource({required this.apiClient});

  Future<List<OperacionCargaModel>> getAll({
    String? estado,
    DateTime? fecha,
  }) async {
    final query = <String, String>{
      if (estado != null && estado.isNotEmpty) 'estado': estado,
      if (fecha != null) 'fecha': fecha.toIso8601String().split('T').first,
    };
    final response = await apiClient.get(
      '/operaciones-carga',
      query: query.isEmpty ? null : query,
    );
    return ResponseParser.extractList(
      response,
    ).map(OperacionCargaModel.fromJson).toList();
  }

  Future<OperacionCargaModel> getById(int id) async {
    final response = await apiClient.get('/operaciones-carga/$id');
    return OperacionCargaModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<OperacionCargaModel> create(OperacionCargaRequestModel request) async {
    final response = await apiClient.post(
      '/operaciones-carga',
      body: request.toCreateJson(),
    );
    return OperacionCargaModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<OperacionCargaModel> update(
    int id, {
    required OperacionCargaRequestModel request,
  }) async {
    final response = await apiClient.put(
      '/operaciones-carga/$id',
      body: request.toUpdateJson(),
    );
    return OperacionCargaModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<OperacionCargaModel> changeEstado({
    required int id,
    required String estado,
  }) async {
    final response = await apiClient.patch(
      '/operaciones-carga/$id/estado',
      body: {'estado': estado},
    );
    return OperacionCargaModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<OperacionCargaModel> cancelar(int id) async {
    final response = await apiClient.delete('/operaciones-carga/$id');
    return OperacionCargaModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<OperacionCargaModel> finalizar(int id) async {
    final response = await apiClient.post('/operaciones-carga/$id/finalizar');
    return OperacionCargaModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<List<GuiaOperacionCargaModel>> generarGuias(int id) async {
    final response = await apiClient.post(
      '/operaciones-carga/$id/generar-guias',
    );
    return ResponseParser.extractList(
      response,
    ).map(GuiaOperacionCargaModel.fromJson).toList();
  }

  Future<List<GuiaOperacionCargaModel>> generarGuiasPorPuesto(int id) async {
    final response = await apiClient.post(
      '/operaciones-carga/$id/generar-guias-por-puesto',
    );
    return ResponseParser.extractList(
      response,
    ).map(GuiaOperacionCargaModel.fromJson).toList();
  }

  Future<List<DetalleCargaModel>> getDetalles(int operacionId) async {
    final response = await apiClient.get(
      '/operaciones-carga/$operacionId/detalles',
    );
    return ResponseParser.extractList(
      response,
    ).map(DetalleCargaModel.fromJson).toList();
  }

  Future<DetalleCargaModel> createDetalle(
    int operacionId,
    DetalleCargaRequestModel request,
  ) async {
    final response = await apiClient.post(
      '/operaciones-carga/$operacionId/detalles',
      body: request.toCreateJson(),
    );
    return DetalleCargaModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<List<DetalleCargaModel>> getDetallesPendientes() async {
    final response = await apiClient.get(
      '/operaciones-carga/detalles-pendientes',
    );
    return ResponseParser.extractList(
      response,
    ).map(DetalleCargaModel.fromJson).toList();
  }

  Future<DetalleCargaModel> updateDetalle(DetalleCarga detalle) async {
    final response = await apiClient.put(
      '/detalle-carga/${detalle.id}',
      preserveNulls: true,
      body: {
        'id_cliente_emisor': detalle.idClienteEmisor,
        'id_fruta': detalle.idFruta,
        'id_variedad': detalle.idVariedad,
        'id_tipo_jaba': detalle.idTipoJaba,
        'cantidad_jabas': detalle.cantidadJabas,
        'instruccion_reparto': detalle.instruccionReparto,
        'observaciones': detalle.observaciones,
        'requiere_retorno_jabas': detalle.requiereRetornoJabas,
      },
    );
    return DetalleCargaModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<DetalleCargaCalidadModel> updateCalidadDetalle(
    DetalleCargaCalidad calidad,
  ) async {
    final response = await apiClient.put(
      '/detalle-carga/calidades/${calidad.id}',
      preserveNulls: true,
      body: {
        'cantidad': calidad.cantidad,
        'precio_unitario': calidad.precioUnitario,
      },
    );
    return DetalleCargaCalidadModel.fromJson(
      ResponseParser.extractObject(response),
    );
  }

  Future<void> deleteDetalle(int detalleId) async {
    await apiClient.delete('/detalle-carga/$detalleId');
  }

  Future<List<DetalleCargaCalidadModel>> getCalidadesDetalle(
    int detalleId,
  ) async {
    final response = await apiClient.get('/detalle-carga/$detalleId/calidades');
    return ResponseParser.extractList(
      response,
    ).map(DetalleCargaCalidadModel.fromJson).toList();
  }

  Future<DetalleCargaCalidadModel> addCalidadDetalle(
    DetalleCargaCalidad calidad,
  ) async {
    final response = await apiClient.post(
      '/detalle-carga/${calidad.idDetalleCarga}/calidades',
      body: DetalleCargaCalidadModel.toCreateJson(calidad),
    );
    return DetalleCargaCalidadModel.fromJson(
      ResponseParser.extractObject(response),
    );
  }

  Future<List<DetalleCargaModel>> getDetallesRepartoPendientes(
    int operacionId,
  ) async {
    final response = await apiClient.get(
      '/operaciones-carga/$operacionId/detalles-reparto-pendientes',
    );
    return ResponseParser.extractList(
      response,
    ).map(DetalleCargaModel.fromJson).toList();
  }
}
