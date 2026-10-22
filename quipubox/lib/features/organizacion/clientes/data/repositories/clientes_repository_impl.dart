import 'package:quipubox/features/organizacion/clientes/data/models/cliente_full_request_model.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente_puesto.dart';

import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente_sede.dart';

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
    return _completeRelations(model.toEntity(), cliente);
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
    return _completeRelations(model.toEntity(), cliente);
  }

  /// Las respuestas de guardado pueden omitir el lugar del puesto o la sede.
  /// Conserva esos objetos del formulario solo si sus claves aún coinciden;
  /// las relaciones y los valores confirmados por la API tienen prioridad.
  Cliente _completeRelations(Cliente saved, Cliente submitted) {
    final sedes = {
      for (final relation in submitted.sedes) relation.idSede: relation.sede,
    };
    final puestos = {
      for (final relation in submitted.puestos)
        relation.idPuesto: relation.puesto,
    };

    return saved.copyWith(
      sedes: saved.sedes.map((relation) {
        final sede = sedes[relation.idSede];
        return relation.copyWith(
          sede: relation.sede ?? (sede?.id == relation.idSede ? sede : null),
        );
      }).toList(),
      puestos: saved.puestos.map((relation) {
        final previous = puestos[relation.idPuesto];
        final matching = previous?.id == relation.idPuesto ? previous : null;
        final puesto = relation.puesto;
        if (puesto == null) return relation.copyWith(puesto: matching);
        final lugar = matching?.lugarOperativo;
        return relation.copyWith(
          puesto: puesto.copyWith(
            lugarOperativo:
                puesto.lugarOperativo ??
                (lugar?.id == puesto.idLugar ? lugar : null),
          ),
        );
      }).toList(),
    );
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
