import '../../domain/entities/camion.dart';
import '../../domain/repositories/camiones_repository.dart';
import '../datasources/camiones_remote_data_source.dart';
import '../models/camion_request_model.dart';

class CamionRepositoryImpl implements CamionRepository {
  final CamionRemoteDataSource remoteDataSource;

  CamionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Camion>> getAll() async {
    final models = await remoteDataSource.getAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Camion> create(Camion camion) async {
    final request = CamionRequestModel.fromEntity(camion);

    final model = await remoteDataSource.create(request);
    return model.toEntity();
  }

  @override
  Future<Camion> update(Camion camion) async {
    final request = CamionRequestModel.fromEntity(camion);

    final model = await remoteDataSource.update(camion.id!, request: request);
    return model.toEntity();
  }

  @override
  Future<bool> changeStatus({required int id, required bool estado}) 
      => remoteDataSource.changeStatus(id: id, estado: estado);
}
