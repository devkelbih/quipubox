import '../../domain/entities/cliente.dart';
import '../../domain/repositories/clientes_repository.dart';
import '../datasources/clientes_remote_data_source.dart';
import '../models/cliente_request_model.dart';
class ClienteRepositoryImpl implements ClienteRepository {
  final ClienteRemoteDataSource remoteDataSource;
  ClienteRepositoryImpl(this.remoteDataSource);
  @override Future<List<Cliente>> getAll({String? buscar}) => remoteDataSource.getAll(buscar: buscar);
  @override Future<Cliente> getById(int id) => remoteDataSource.getById(id);
  @override Future<Cliente> create(ClienteRequestModel request) => remoteDataSource.create(request);
  @override Future<Cliente> update(int id, {required ClienteRequestModel request}) => remoteDataSource.update(id, request: request);
  @override Future<void> delete(int id) => remoteDataSource.delete(id);
  @override Future<void> assignSede({required int idCliente, required int idSede, required String tipoRelacion}) => remoteDataSource.assignSede(idCliente: idCliente, idSede: idSede, tipoRelacion: tipoRelacion);
  @override Future<void> assignPuesto({required int idCliente, required int idPuesto, String? seccion}) => remoteDataSource.assignPuesto(idCliente: idCliente, idPuesto: idPuesto, seccion: seccion);
  @override Future<void> deletePuesto({required int idCliente, required int idPuesto}) => remoteDataSource.deletePuesto(idCliente: idCliente, idPuesto: idPuesto);
}
