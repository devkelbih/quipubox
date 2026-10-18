import '../../domain/entities/variedad.dart';
import '../../domain/repositories/variedad_repository.dart';
import '../datasources/variedad_remote_data_source.dart';
import '../models/variedad_request_model.dart';

class VariedadRepositoryImpl implements VariedadRepository {
  final VariedadRemoteDataSource remoteDataSource;

  VariedadRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Variedad>> getAll() async {
    final models = await remoteDataSource.getAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Variedad> create(Variedad variedad) async {
    final request = VariedadRequestModel.fromEntity(variedad);
    final model = await remoteDataSource.create(request);
    return model.toEntity();
  }

  @override
  Future<Variedad> update(Variedad variedad) async {
    final request = VariedadRequestModel.fromEntity(variedad);
    final model = await remoteDataSource.update(variedad.id!, request: request);
    return model.toEntity();
  }

  @override
  Future<bool> changeStatus({required int id, required bool estado}) =>
      remoteDataSource.changeStatus(id: id, estado: estado);
}
