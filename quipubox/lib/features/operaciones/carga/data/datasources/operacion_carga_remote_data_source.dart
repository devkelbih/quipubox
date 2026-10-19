import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/response_parser.dart';
import '../models/detalle_carga_model.dart';
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
