import 'package:quipubox/core/network/response_parser.dart';

import '../../../../core/network/api_client.dart';
import '../models/calidad_model.dart';
import '../models/calidad_request_model.dart';

class CalidadRemoteDataSource {
  final ApiClient apiClient;

  CalidadRemoteDataSource(this.apiClient);

  Future<List<CalidadModel>> getAll() async {
    final response = await apiClient.get('/calidades');

    return ResponseParser.extractList(
      response,
    ).map(CalidadModel.fromJson).toList();
  }

  Future<CalidadModel> create(CalidadRequestModel request) async {
    final response = await apiClient.post(
      '/calidades',
      body: request.toCreateJson(),
    );
    return CalidadModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<CalidadModel> update(
    int id, {
    required CalidadRequestModel request,
  }) async {
    final response = await apiClient.put(
      '/calidades/$id',
      body: request.toUpdateJson(),
    );
    return CalidadModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<bool> changeStatus({required int id, required bool estado}) async {
    final respose = await apiClient.patch(
      '/calidades/$id/estado',
      body: {'estado': estado},
    );
    final data = ResponseParser.extractObject(respose);
    return data['estado'] == true;
  }
}
