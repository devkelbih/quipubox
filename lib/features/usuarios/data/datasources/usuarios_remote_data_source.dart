import '../../../../core/network/api_client.dart';
import '../../../../core/network/response_parser.dart';
import '../models/usuario_model.dart';
import '../models/usuario_request_model.dart';

class UsuarioRemoteDataSource {
  final ApiClient apiClient;

  UsuarioRemoteDataSource(this.apiClient);

  Future<List<UsuarioModel>> getAll() async {
    final response = await apiClient.get('/usuarios');

    return ResponseParser.extractList(
      response,
    ).map(UsuarioModel.fromJson).toList();
  }

  Future<UsuarioModel> create(UsuarioRequestModel request) async {
    final response = await apiClient.post(
      '/usuarios/full',
      body: request.toCreateJson(),
    );

    return UsuarioModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<UsuarioModel> update(
    int id, {
    required UsuarioRequestModel request,
  }) async {
    await Future.delayed(const Duration(seconds: 3));
    final response = await apiClient.put(
      '/usuarios/$id/full',
      body: request.toUpdateJson(),
    );

    return UsuarioModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<bool> changeStatus({required int id, required bool estado}) async {
    final response = await apiClient.patch(
      '/usuarios/$id/estado',
      body: {'estado': estado},
    );

    final data = ResponseParser.extractObject(response);

    return data['estado'] == true;
  }
}
