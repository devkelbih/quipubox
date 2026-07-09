import 'package:quipubox/core/network/response_parser.dart';

import '../../../../core/network/api_client.dart';
import '../models/variedad_model.dart';
import '../models/variedad_request_model.dart';

class VariedadRemoteDataSource {
  final ApiClient apiClient;

  VariedadRemoteDataSource(this.apiClient);

  Future<List<VariedadModel>> getAll() async {
    final response = await apiClient.get('/variedades');
    return ResponseParser.extractList(
      response,
    ).map(VariedadModel.fromJson).toList();
  }

  /*
  //OBTENER VARIEDADES POR FRUTA
  Future<List<VariedadModel>> getByFruta(int frutaId) async =>
      VariedadModel.listFrom(
        await apiClient.get('/variedades/frutas/$frutaId/variedades'),
      );*/

  Future<VariedadModel> create(VariedadRequestModel request) async {
    final response = await apiClient.post(
      '/variedades',
      body: request.toCreateJson(),
    );
    return VariedadModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<VariedadModel> update(
    int id, {
    required VariedadRequestModel request,
  }) async {
    final response = await apiClient.put(
      '/variedades/$id',
      body: request.toUpdateJson(),
    );
    return VariedadModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<bool> changeStatus({required int id, required bool estado}) async {
    final response = await apiClient.patch(
      '/variedades/$id/estado',
      body: {'estado': estado},
    );
    final data = ResponseParser.extractObject(response);
    return data['estado'] == true;
  }
}
