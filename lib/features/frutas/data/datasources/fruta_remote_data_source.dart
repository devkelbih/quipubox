import 'package:quipubox/core/network/response_parser.dart';

import '../../../../core/network/api_client.dart';
import '../models/fruta_model.dart';
import '../models/fruta_request_model.dart';

class FrutaRemoteDataSource {
  final ApiClient apiClient;

  FrutaRemoteDataSource(this.apiClient);

  Future<List<FrutaModel>> getAll() async {
    final response = await apiClient.get('/frutas');

    return ResponseParser.extractList(
      response,
    ).map(FrutaModel.fromJson).toList();
  }

  Future<FrutaModel> create(FrutaRequestModel request) async {
    final response = await apiClient.post(
      '/frutas',
      body: request.toCreateJson(),
    );

    return FrutaModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<FrutaModel> update(
    int id, {
    required FrutaRequestModel request,
  }) async {
    final response = await apiClient.put(
      '/frutas/$id',
      body: request.toUpdateJson(),
    );
    return FrutaModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<bool> changeStatus({required int id, required bool estado}) async {
    final response = await apiClient.patch(
      '/frutas/$id/estado',
      body: {'estado': estado},
    );
    final data = ResponseParser.extractObject(response);
    return data['estado'] == true;
  }
}
