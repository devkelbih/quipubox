import '../../../../core/network/api_client.dart';
import '../models/tipos_jaba_model.dart';
import '../models/tipos_jaba_request_model.dart';

class TipoJabaRemoteDataSource {
  final ApiClient apiClient;
  TipoJabaRemoteDataSource(this.apiClient);

  Future<List<TipoJabaModel>> getAll() async =>
      TipoJabaModel.listFrom(await apiClient.get('/tipos-jaba'));

  Future<TipoJabaModel> create(TipoJabaRequestModel request) async =>
      TipoJabaModel.fromJson(
        await apiClient.post('/tipos-jaba', body: request.toCreateJson())
            as Map<String, dynamic>,
      );

  Future<TipoJabaModel> update(
    int id, {
    required TipoJabaRequestModel request,
  }) async => TipoJabaModel.fromJson(
    await apiClient.put('/tipos-jaba/$id', body: request.toUpdateJson())
        as Map<String, dynamic>,
  );
  
    Future<TipoJabaModel> changeStatus({
    required int id,
    required bool estado,
  }) async {
    return TipoJabaModel.fromJson(
      await apiClient.patch('/tipos-jaba/$id/estado', body: {'estado': estado})
          as Map<String, dynamic>,
    );
  }
}
