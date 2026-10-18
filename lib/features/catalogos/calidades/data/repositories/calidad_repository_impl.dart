import '../../domain/entities/calidad.dart';
import '../../domain/repositories/calidad_repository.dart';
import '../datasources/calidad_remote_data_source.dart';
import '../models/calidad_request_model.dart';

class CalidadRepositoryImpl implements CalidadRepository {
  final CalidadRemoteDataSource remoteDataSource;

  CalidadRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Calidad>> getAll() async {
    final models = await remoteDataSource.getAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Calidad> create(Calidad calidad) async {
    final request = CalidadRequestModel.fromEntity(calidad);
    final model = await remoteDataSource.create(request);
    return model.toEntity();
  }

  @override
  Future<Calidad> update(Calidad calidad) async {
  final request = CalidadRequestModel.fromEntity(calidad);
  final model = await remoteDataSource.update(calidad.id!, request: request);
  return model.toEntity();
  }

  @override
  Future<bool> changeStatus({required int id, required bool estado}) =>
      remoteDataSource.changeStatus(id: id, estado: estado);
}
