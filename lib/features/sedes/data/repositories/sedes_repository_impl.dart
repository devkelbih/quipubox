import '../../../../core/exceptions/app_exception.dart';
import '../../domain/entities/sede.dart';
import '../../domain/repositories/sedes_repository.dart';
import '../datasources/sedes_remote_data_source.dart';
import '../models/sede_request_model.dart';

class SedeRepositoryImpl implements SedeRepository {
  final SedeRemoteDataSource remoteDataSource;

  SedeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Sede>> getAll() async {
    return remoteDataSource.getAll();
  }

  @override
  Future<Sede> create(Sede sede) async {
    final request = SedeRequestModel.fromEntity(sede);

    return remoteDataSource.create(request);
  }

  @override
  Future<Sede> update(Sede sede) async {
    final id = sede.id;
    if (id == null) {
      throw const AppException('No se encontró el ID de la sede.');
    }
    final request = SedeRequestModel.fromEntity(sede);
    return remoteDataSource.update(id, request: request);
  }

  @override
  Future<Sede> changeStatus({required int id, required bool estado}) async {
    return remoteDataSource.changeStatus(id: id, estado: estado);
  }
}
