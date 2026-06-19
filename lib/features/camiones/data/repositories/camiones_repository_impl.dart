import '../../domain/entities/camion.dart';
import '../../domain/repositories/camiones_repository.dart';
import '../datasources/camiones_remote_data_source.dart';
import '../models/camion_request_model.dart';

class CamionRepositoryImpl implements CamionRepository {
  final CamionRemoteDataSource remoteDataSource;

  CamionRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Camion>> getAll() async {
    return remoteDataSource.getAll();
  }

  @override
  Future<Camion> create(Camion camion) async {

    final request = CamionRequestModel.fromEntity(camion);

    return remoteDataSource.create(request);
  }

  @override
  Future<Camion> update(Camion camion) async {

    final request = CamionRequestModel.fromEntity(camion);

    return remoteDataSource.update(
      camion.id,
      request: request,
    );
  }

  @override
  Future<Camion> changeStatus({
    required int id,
    required bool estado,
  }) async {

    return remoteDataSource.changeStatus(
      id: id,
      estado: estado,
    );
  }


}