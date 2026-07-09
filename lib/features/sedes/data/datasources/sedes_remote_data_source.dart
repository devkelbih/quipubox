import 'package:quipubox/core/network/response_parser.dart';

import '../../../../core/network/api_client.dart';
import '../models/sede_model.dart';
import '../models/sede_request_model.dart';

class SedeRemoteDataSource {
  final ApiClient apiClient;
  SedeRemoteDataSource(this.apiClient);

  Future<List<SedeModel>> getAll() async {
    final response = await apiClient.get('/sedes');

    return ResponseParser.extractList(
      response,
    ).map(SedeModel.fromJson).toList();
  }

  Future<SedeModel> create(SedeRequestModel request) async {
    final response = await apiClient.post(
      '/sedes',
      body: request.toCreateJson(),
    );

    return SedeModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<SedeModel> update(int id, {required SedeRequestModel request}) async {
    final response = await apiClient.put(
      '/sedes/$id',
      body: request.toUpdateJson(),
    );

    return SedeModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<bool> changeStatus({required int id, required bool estado}) async {
    final response = await apiClient.patch(
      '/sedes/$id/estado',
      body: {'estado': estado},
    );
    final data = ResponseParser.extractObject(response);
    return data['estado'] == true;
  }
}
