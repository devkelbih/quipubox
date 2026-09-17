import 'package:quipubox/core/network/response_parser.dart';

import '../../../../core/network/api_client.dart';
import '../models/lugar_operativo_model.dart';
import '../models/lugar_operativo_request_model.dart';

class LugarOperativoRemoteDataSource {
  final ApiClient apiClient;

  LugarOperativoRemoteDataSource(this.apiClient);

  Future<List<LugarOperativoModel>> getAll() async {
    final response = await apiClient.get('/lugares-operativos');

    return ResponseParser.extractList(
      response,
    ).map(LugarOperativoModel.fromJson).toList();
  }

  Future<LugarOperativoModel> create(LugarOperativoRequestModel request) async {
    final response = await apiClient.post(
      '/lugares-operativos',
      body: request.toCreateJson(),
    );

    return LugarOperativoModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<LugarOperativoModel> update(
    int id,
    LugarOperativoRequestModel request,
  ) async {
    final response = await apiClient.put(
      '/lugares-operativos/$id',
      body: request.toUpdateJson(),
    );

    return LugarOperativoModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<bool> changeStatus({required int id, required bool estado}) async {
    final response = await apiClient.patch(
      '/lugares-operativos/$id/estado',
      body: {'estado': estado},
    );

    final data = ResponseParser.extractObject(response);
    return data['estado'] == true;
  }
}
