import '../../../../core/network/api_client.dart';
import '../models/calidad_model.dart';
import '../models/calidad_request_model.dart';
class CalidadRemoteDataSource {
  final ApiClient apiClient;
  CalidadRemoteDataSource(this.apiClient);
  Future<List<CalidadModel>> getAll() async => CalidadModel.listFrom(await apiClient.get('/calidades'));
  Future<CalidadModel> create(CalidadRequestModel request) async => CalidadModel.fromJson(await apiClient.post('/calidades', body: request.toCreateJson()) as Map<String, dynamic>);
  Future<CalidadModel> update(int id, {required CalidadRequestModel request}) async => CalidadModel.fromJson(await apiClient.patch('/calidades/$id', body: request.toUpdateJson()) as Map<String, dynamic>);
  Future<void> delete(int id) async => apiClient.delete('/calidades/$id');
}
