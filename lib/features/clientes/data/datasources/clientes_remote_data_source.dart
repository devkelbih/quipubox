import 'package:quipubox/core/network/response_parser.dart';

import '../../../../core/network/api_client.dart';
import '../models/cliente_model.dart';
import '../models/cliente_request_model.dart';

class ClienteRemoteDataSource {
  final ApiClient apiClient;
  ClienteRemoteDataSource({required this.apiClient});
  Future<bool> changeStatus({required int id, required bool estado}) async {
    final response = await apiClient.patch(
      '/clientes/$id/estado',
      body: {'estado': estado},
    );

    final data = ResponseParser.extractObject(response);

    return data['estado'] == true;
  }

  Future<ClienteModel> create(ClienteRequestModel request) async {
    final response = await apiClient.post(
      '/clientes/full',
      body: request.toCreateJson(),
    );

    return ClienteModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<ClienteModel> update(
    int id, {
    required ClienteRequestModel request,
  }) async {
    final response = await apiClient.put(
      '/clientes/$id/full',
      body: request.toUpdateJson(),
    );

    return ClienteModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<List<ClienteModel>> getAll() async {
    final response = await apiClient.get('/clientes');

    return ResponseParser.extractList(
      response,
    ).map(ClienteModel.fromJson).toList();
  }
}
