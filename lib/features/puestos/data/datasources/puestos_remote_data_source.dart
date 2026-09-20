import 'package:quipubox/core/network/response_parser.dart';
import 'package:quipubox/features/puestos/data/models/puesto_request_model.dart';

import '../../../../core/network/api_client.dart';
import '../models/puesto_model.dart';

class PuestoRemoteDataSource {
  final ApiClient apiClient;
  PuestoRemoteDataSource({required this.apiClient});
  Future<List<PuestoModel>> getAll() async {
    final response = await apiClient.get('/puestos');
    return ResponseParser.extractList(
      response,
    ).map(PuestoModel.fromJson).toList();
  }

  Future<PuestoModel> create(PuestoRequestModel request) async {
    final response = await apiClient.post(
      '/puestos',
      body: request.toCreateJson(),
    );
    return PuestoModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<PuestoModel> update(
    int id, {
    required PuestoRequestModel request,
  }) async {
    final response = await apiClient.put(
      '/puestos/$id',
      body: request.toUpdateJson(),
    );
    return PuestoModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<bool> changeStatus({required int id, required bool estado}) async {
    final response = await apiClient.patch(
      '/puestos/$id/estado',
      body: {'estado': estado},
    );
    final data = ResponseParser.extractObject(response);
    return data['estado'] == true;
  }
}
