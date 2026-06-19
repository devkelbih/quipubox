import '../../../../core/network/api_client.dart';
import '../models/fruta_model.dart';
import '../models/fruta_request_model.dart';

class FrutaRemoteDataSource {
  final ApiClient apiClient;

  FrutaRemoteDataSource(this.apiClient);

  Future<List<FrutaModel>> getAll() async =>
      FrutaModel.listFrom(await apiClient.get('/frutas'));

  Future<FrutaModel> create(FrutaRequestModel request) async =>
      FrutaModel.fromJson(
        await apiClient.post('/frutas', body: request.toCreateJson())
            as Map<String, dynamic>,
      );

  Future<FrutaModel> update(
    int id, {
    required FrutaRequestModel request,
  }) async =>
      FrutaModel.fromJson(
        await apiClient.put('/frutas/$id', body: request.toUpdateJson())
            as Map<String, dynamic>,
      );

  Future<FrutaModel> changeStatus({
    required int id,
    required bool estado,
  }) async {
    return FrutaModel.fromJson(
      await apiClient.patch('/frutas/$id/estado', body: {'estado': estado})
          as Map<String, dynamic>,
    );
  }
}
