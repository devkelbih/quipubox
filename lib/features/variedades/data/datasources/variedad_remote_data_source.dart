import '../../../../core/network/api_client.dart';
import '../models/variedad_model.dart';
import '../models/variedad_request_model.dart';

class VariedadRemoteDataSource {
  final ApiClient apiClient;

  VariedadRemoteDataSource(this.apiClient);

  Future<List<VariedadModel>> getAll() async =>
      VariedadModel.listFrom(await apiClient.get('/variedades'));

  Future<List<VariedadModel>> getByFruta(int frutaId) async =>
      VariedadModel.listFrom(
        await apiClient.get('/variedades/frutas/$frutaId/variedades'),
      );

  Future<VariedadModel> create(VariedadRequestModel request) async =>
      VariedadModel.fromJson(
        await apiClient.post('/variedades', body: request.toCreateJson())
            as Map<String, dynamic>,
      );

  Future<VariedadModel> update(
    int id, {
    required VariedadRequestModel request,
  }) async =>
      VariedadModel.fromJson(
        await apiClient.put('/variedades/$id', body: request.toUpdateJson())
            as Map<String, dynamic>,
      );

  Future<VariedadModel> changeStatus({
    required int id,
    required bool estado,
  }) async {
    return VariedadModel.fromJson(
      await apiClient.patch('/variedades/$id/estado', body: {'estado': estado})
          as Map<String, dynamic>,
    );
  }
}
