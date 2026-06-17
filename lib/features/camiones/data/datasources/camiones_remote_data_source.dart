import '../../../../core/network/api_client.dart';
import '../models/camion_model.dart';
import '../models/camion_request_model.dart';

class CamionRemoteDataSource {
  final ApiClient apiClient;
  CamionRemoteDataSource(this.apiClient);

  Future<List<CamionModel>> getAll() async =>
      CamionModel.listFrom(await apiClient.get('/camiones'));

  Future<CamionModel> create(CamionRequestModel request) async =>
      CamionModel.fromJson(
        await apiClient.post('/camiones', body: request.toCreateJson())
            as Map<String, dynamic>,
      );

  Future<CamionModel> update(
    int id, {
    required CamionRequestModel request,
  }) async => CamionModel.fromJson(
    await apiClient.put('/camiones/$id', body: request.toUpdateJson())
        as Map<String, dynamic>,
  );
  
  Future<CamionModel> changeStatus({
    required int id,
    required bool estado,
  }) async {
    return CamionModel.fromJson(
      await apiClient.patch('/camiones/$id/estado', body: {'estado': estado})
          as Map<String, dynamic>,
    );
  }
}
