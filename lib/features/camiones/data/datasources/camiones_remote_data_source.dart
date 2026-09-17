import 'package:quipubox/core/network/response_parser.dart';

import '../../../../core/network/api_client.dart';
import '../models/camion_model.dart';
import '../models/camion_request_model.dart';

class CamionRemoteDataSource {
  final ApiClient apiClient;
  CamionRemoteDataSource(this.apiClient);

  Future<List<CamionModel>> getAll() async {
    final response = await apiClient.get('/camiones');

    return ResponseParser.extractList(
      response,
    ).map(CamionModel.fromJson).toList();
  }

  Future<CamionModel> create(CamionRequestModel request) async {
    final response = await apiClient.post(
      '/camiones',
      body: request.toCreateJson(),
    );

    return CamionModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<CamionModel> update(
    int id, {
    required CamionRequestModel request,
  }) async {
    final response = await apiClient.put(
      '/camiones/$id',
      body: request.toUpdateJson(),
    );

    return CamionModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<bool> changeStatus({required int id, required bool estado}) async {
    final response = await apiClient.patch(
      '/camiones/$id/estado',
      body: {'estado': estado},
    );
    final data = ResponseParser.extractObject(response);

    return data['estado'] == true;
  }
}
