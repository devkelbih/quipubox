import 'package:quipubox/features/clientes/data/models/cliente_full_request_model.dart';
import 'package:quipubox/features/clientes/domain/entities/cliente_puesto.dart';

import 'package:quipubox/features/clientes/domain/entities/cliente_sede.dart';

import '../../domain/entities/cliente.dart';
import '../../domain/repositories/clientes_repository.dart';
import '../datasources/clientes_remote_data_source.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  final ClienteRemoteDataSource remoteDataSource;

  ClienteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> changeStatus({required int id, required bool estado}) {
    return remoteDataSource.changeStatus(id: id, estado: estado);
  }

  @override
  Future<Cliente> create(Cliente cliente) async {
    final requestModel = ClienteFullRequestModel.fromEntity(cliente);
    final model = await remoteDataSource.create(requestModel);
    return model.toEntity();
  }

  @override
  Future<List<Cliente>> getAll() async {
    final models = await remoteDataSource.getAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Cliente> update(Cliente cliente) async {
    final requestModel = ClienteFullRequestModel.fromEntity(cliente);
    final model = await remoteDataSource.update(
      cliente.id!,
      request: requestModel,
    );
    return model.toEntity();
  }

  @override
  Future<ClientePuesto> addClientePuesto(ClientePuesto clientePuesto) {
    // TODO: Definir flujo independiente de puestos con API Backend.
    throw UnimplementedError();
  }

  @override
  Future<ClienteSede> addClienteSede(ClienteSede clienteSede) {
    // TODO: Corregir/definir endpoint POST /clientes/{id}/sedes con API Backend.
    throw UnimplementedError();
  }

  @override
  Future<ClienteSede> updateClienteSedeRelation(ClienteSede clienteSede) {
    // TODO: Implementar flujo independiente de actualización de sede (relacion).
    throw UnimplementedError();
  }
}
