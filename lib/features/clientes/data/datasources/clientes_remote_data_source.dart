import '../../../../core/network/api_client.dart';
import '../models/cliente_model.dart';
import '../models/cliente_request_model.dart';
class ClienteRemoteDataSource {
  final ApiClient apiClient;
  ClienteRemoteDataSource(this.apiClient);
  Future<List<ClienteModel>> getAll({String? buscar}) async => ClienteModel.listFrom(await apiClient.get('/clientes', query: buscar == null || buscar.trim().isEmpty ? null : {'buscar': buscar.trim()}));
  Future<ClienteModel> getById(int id) async => ClienteModel.fromJson(await apiClient.get('/clientes/$id') as Map<String, dynamic>);
  Future<ClienteModel> create(ClienteRequestModel request) async => ClienteModel.fromJson(await apiClient.post('/clientes', body: request.toCreateJson()) as Map<String, dynamic>);
  Future<ClienteModel> update(int id, {required ClienteRequestModel request}) async => ClienteModel.fromJson(await apiClient.put('/clientes/$id', body: request.toUpdateJson()) as Map<String, dynamic>);
  Future<void> delete(int id) async => apiClient.delete('/clientes/$id');
  Future<void> assignSede({required int idCliente, required int idSede, required String tipoRelacion}) async => apiClient.post('/clientes/sedes', body: {'id_cliente': idCliente, 'id_sede': idSede, 'tipo_relacion': tipoRelacion});
  Future<dynamic> getSedes(int idCliente) => apiClient.get('/clientes/$idCliente/sedes');
  Future<void> assignPuesto({required int idCliente, required int idPuesto, String? seccion}) async => apiClient.post('/clientes/$idCliente/puestos', body: {'id_puesto': idPuesto, if (seccion != null && seccion.trim().isNotEmpty) 'seccion': seccion.trim()});
  Future<dynamic> getPuestos(int idCliente) => apiClient.get('/clientes/$idCliente/puestos');
  Future<void> deletePuesto({required int idCliente, required int idPuesto}) async => apiClient.delete('/clientes/$idCliente/puestos/$idPuesto');
}
