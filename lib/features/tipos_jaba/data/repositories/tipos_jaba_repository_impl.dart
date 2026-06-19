import 'package:quipubox/core/exceptions/app_exception.dart';

import '../../domain/entities/tipos_jaba.dart';
import '../../domain/repositories/tipos_jaba_repository.dart';
import '../datasources/tipos_jaba_remote_data_source.dart';
import '../models/tipos_jaba_request_model.dart';

class TipoJabaRepositoryImpl implements TipoJabaRepository {
  final TipoJabaRemoteDataSource remoteDataSource;
  TipoJabaRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<TipoJaba> changeStatus({required int id, required bool estado}) async {

    return remoteDataSource.changeStatus(id: id, estado: estado);
  }

  @override
  Future<TipoJaba> create(TipoJaba tipoJaba) async {

    final request = TipoJabaRequestModel.fromEntity(tipoJaba);

    return remoteDataSource.create(request);
  }

  @override
  Future<List<TipoJaba>> getAll() async {
    return remoteDataSource.getAll();
  }

  @override
  Future<TipoJaba> update(TipoJaba tipoJaba) async {
    final id = tipoJaba.id;
    if (id == null) {
      throw const AppException('No se encontró el ID del tipo de jaba.');
    }
    final request = TipoJabaRequestModel.fromEntity(tipoJaba);
    return remoteDataSource.update(id, request: request);
  }

}
