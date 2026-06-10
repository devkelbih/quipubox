import '../../../../core/network/api_client.dart';
import '../models/puesto_model.dart';
import '../models/puesto_request_model.dart';
class PuestoRemoteDataSource {
  final ApiClient apiClient;
  PuestoRemoteDataSource(this.apiClient);
  Future<List<PuestoModel>> getAll() async => PuestoModel.listFrom(await apiClient.get('/puestos'));
  Future<PuestoModel> create(PuestoRequestModel request) async => PuestoModel.fromJson(await apiClient.post('/puestos', body: request.toCreateJson()) as Map<String, dynamic>);
  Future<PuestoModel> update(int id, {required PuestoRequestModel request}) async => PuestoModel.fromJson(await apiClient.put('/puestos/$id', body: request.toUpdateJson()) as Map<String, dynamic>);
  Future<void> delete(int id) async => apiClient.delete('/puestos/$id');
}
