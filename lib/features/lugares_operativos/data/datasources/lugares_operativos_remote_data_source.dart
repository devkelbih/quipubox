import '../../../../core/network/api_client.dart';
import '../models/lugar_operativo_model.dart';
import '../models/lugar_operativo_request_model.dart';
class LugarOperativoRemoteDataSource {
  final ApiClient apiClient;
  LugarOperativoRemoteDataSource(this.apiClient);
  Future<List<LugarOperativoModel>> getAll() async => LugarOperativoModel.listFrom(await apiClient.get('/lugares-operativos'));
  Future<LugarOperativoModel> create(LugarOperativoRequestModel request) async => LugarOperativoModel.fromJson(await apiClient.post('/lugares-operativos', body: request.toCreateJson()) as Map<String, dynamic>);
  Future<LugarOperativoModel> update(int id, {required LugarOperativoRequestModel request}) async => LugarOperativoModel.fromJson(await apiClient.put('/lugares-operativos/$id', body: request.toUpdateJson()) as Map<String, dynamic>);
  Future<void> delete(int id) async => apiClient.delete('/lugares-operativos/$id');
}
