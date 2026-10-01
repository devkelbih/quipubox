import 'package:quipubox/features/clientes/domain/entities/cliente_puesto.dart';

import 'package:quipubox/features/clientes/domain/entities/cliente_sede.dart';

import '../../domain/entities/cliente.dart';
import '../../domain/repositories/clientes_repository.dart';
import '../datasources/clientes_remote_data_source.dart';
import '../models/cliente_request_model.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  final ClienteRemoteDataSource remoteDataSource;

  ClienteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ClientePuesto> addClientePuesto(ClientePuesto clientePuesto) {
    // TODO: implement addClientePuesto
    throw UnimplementedError();
  }

  @override
  Future<ClienteSede> addClienteSede(ClienteSede clienteSede) {
    // TODO: implement addClienteSede
    throw UnimplementedError();
  }

  @override
  Future<void> assignPuesto({
    required int idCliente,
    required int idPuesto,
    String? seccion,
  }) {
    // TODO: implement assignPuesto
    throw UnimplementedError();
  }

  @override
  Future<void> assignSede({
    required int idCliente,
    required int idSede,
    required String tipoRelacion,
  }) {
    // TODO: implement assignSede
    throw UnimplementedError();
  }

  @override
  Future<bool> changeStatus({required int id, required bool estado}) {
    return remoteDataSource.changeStatus(id: id, estado: estado);
  }

  @override
  Future<Cliente> create(Cliente cliente) async {
    final requestModel = ClienteRequestModel.fromEntity(cliente);
    final model = await remoteDataSource.create(requestModel);
    return model.toEntity();
  }

  @override
  Future<void> deletePuesto({required int idCliente, required int idPuesto}) {
    // TODO: implement deletePuesto
    throw UnimplementedError();
  }

  @override
  Future<List<Cliente>> getAll() async {
    final models = await remoteDataSource.getAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Cliente> update(Cliente cliente) async {
    final requestModel = ClienteRequestModel.fromEntity(cliente);
    final model = await remoteDataSource.update(
      cliente.id!,
      request: requestModel,
    );
    return model.toEntity();
  }

  @override
  Future<ClienteSede> updateClienteSedeRelation(ClienteSede clienteSede) {
    // TODO: implement updateClienteSedeRelation
    throw UnimplementedError();
  }
}
