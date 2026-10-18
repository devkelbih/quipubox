import '../../domain/entities/sede.dart';
import '../../domain/repositories/sedes_repository.dart';
import '../datasources/sedes_remote_data_source.dart';
import '../models/sede_request_model.dart';

class SedeRepositoryImpl implements SedeRepository {
  final SedeRemoteDataSource remoteDataSource;

  SedeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Sede>> getAll() async {
    final models = await remoteDataSource.getAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Sede> create(Sede sede) async {
    final request = SedeRequestModel.fromEntity(sede);

    final model = await remoteDataSource.create(request);
    return model.toEntity();
  }

  @override
  Future<Sede> update(Sede sede) async {
    final request = SedeRequestModel.fromEntity(sede);

    final model = await remoteDataSource.update(sede.id!, request: request);
    return model.toEntity();
  }

  @override
  Future<bool> changeStatus({required int id, required bool estado}) =>
      remoteDataSource.changeStatus(id: id, estado: estado);
}
