import '../../data/models/cliente_request_model.dart';
import '../entities/cliente.dart';
abstract class ClienteRepository {
  Future<List<Cliente>> getAll({String? buscar});
  Future<Cliente> getById(int id);
  Future<Cliente> create(ClienteRequestModel request);
  Future<Cliente> update(int id, {required ClienteRequestModel request});
  Future<void> delete(int id);
  Future<void> assignSede({required int idCliente, required int idSede, required String tipoRelacion});
  Future<void> assignPuesto({required int idCliente, required int idPuesto, String? seccion});
  Future<void> deletePuesto({required int idCliente, required int idPuesto});
}
