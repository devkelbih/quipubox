import '../../../../core/network/api_client.dart';
import '../models/sede_model.dart';
import '../models/sede_request_model.dart';

class SedeRemoteDataSource {
  final ApiClient apiClient;
  SedeRemoteDataSource(this.apiClient);

  Future<List<SedeModel>> getAll() async =>
      SedeModel.listFrom(await apiClient.get('/sedes'));

  Future<SedeModel> create(SedeRequestModel request) async =>
      SedeModel.fromJson(
        await apiClient.post('/sedes', body: request.toCreateJson())
            as Map<String, dynamic>,
      );

  Future<SedeModel> update(int id, {required SedeRequestModel request}) async =>
      SedeModel.fromJson(
        await apiClient.put('/sedes/$id', body: request.toUpdateJson())
            as Map<String, dynamic>,
      );
      
  Future<SedeModel> changeStatus({
    required int id,
    required bool estado,
  }) async {
    return SedeModel.fromJson(
      await apiClient.patch('/sedes/$id/estado', body: {'estado': estado})
          as Map<String, dynamic>,
    );
  }
}
