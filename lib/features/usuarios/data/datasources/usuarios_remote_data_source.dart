import '../../../../core/network/api_client.dart';
import '../models/usuario_model.dart';
import '../models/usuario_request_model.dart';

class UsuarioRemoteDataSource {
  final ApiClient apiClient;

  UsuarioRemoteDataSource(this.apiClient);

  Future<List<UsuarioModel>> getAll() async =>
      UsuarioModel.listFrom(await apiClient.get('/usuarios'));

  Future<UsuarioModel> create(UsuarioRequestModel request) async =>
      UsuarioModel.fromJson(
        await apiClient.post('/usuarios', body: request.toCreateJson())
            as Map<String, dynamic>,
      );

  Future<UsuarioModel> update(
    int id, {
    required UsuarioRequestModel request,
  }) async => UsuarioModel.fromJson(
    await apiClient.put('/usuarios/$id', body: request.toUpdateJson())
        as Map<String, dynamic>,
  );
  
  Future<bool> changeStatus({required int id, required bool estado}) async {
    final response =
        await apiClient.patch('/usuarios/$id/estado', body: {'estado': estado})
            as Map<String, dynamic>;

    return response['estado'] == true;
  }
}
