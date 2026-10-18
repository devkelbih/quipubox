import '../../domain/entities/fruta.dart';
import '../../domain/repositories/fruta_repository.dart';
import '../datasources/fruta_remote_data_source.dart';
import '../models/fruta_request_model.dart';

class FrutaRepositoryImpl implements FrutaRepository {
  final FrutaRemoteDataSource remoteDataSource;

  FrutaRepositoryImpl({required this.remoteDataSource});
  @override
  Future<List<Fruta>> getAll() async {
    final models = remoteDataSource.getAll();
    return models.then(
      (value) => value.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<Fruta> create(Fruta fruta) async {
    final request = FrutaRequestModel.fromEntity(fruta);
    final model = await remoteDataSource.create(request);
    return model.toEntity();
  }

  @override
  Future<Fruta> update(Fruta fruta) async {
    final request = FrutaRequestModel.fromEntity(fruta);
    final model = await remoteDataSource.update(fruta.id!, request: request);
    return model.toEntity();
  }

  @override
  Future<bool> changeStatus({required int id, required bool estado}) =>
      remoteDataSource.changeStatus(id: id, estado: estado);
}
