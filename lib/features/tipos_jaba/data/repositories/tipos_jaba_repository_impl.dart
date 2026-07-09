import '../../domain/entities/tipos_jaba.dart';
import '../../domain/repositories/tipos_jaba_repository.dart';
import '../datasources/tipos_jaba_remote_data_source.dart';
import '../models/tipos_jaba_request_model.dart';

class TipoJabaRepositoryImpl implements TipoJabaRepository {
  final TipoJabaRemoteDataSource remoteDataSource;
  TipoJabaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TipoJaba> create(TipoJaba tipoJaba) async {
    final request = TipoJabaRequestModel.fromEntity(tipoJaba);

    final model = await remoteDataSource.create(request);
    return model.toEntity();
  }

  @override
  Future<List<TipoJaba>> getAll() async {
    final models = await remoteDataSource.getAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<TipoJaba> update(TipoJaba tipoJaba) async {
    final request = TipoJabaRequestModel.fromEntity(tipoJaba);

    final model = await remoteDataSource.update(tipoJaba.id!, request: request);
    return model.toEntity();
  }

  @override
  Future<bool> changeStatus({required int id, required bool estado}) =>
      remoteDataSource.changeStatus(id: id, estado: estado);
}
