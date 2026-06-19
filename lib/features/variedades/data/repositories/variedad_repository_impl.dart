import 'package:quipubox/core/exceptions/app_exception.dart';

import '../../domain/entities/variedad.dart';
import '../../domain/repositories/variedad_repository.dart';
import '../datasources/variedad_remote_data_source.dart';
import '../models/variedad_request_model.dart';

class VariedadRepositoryImpl implements VariedadRepository {
  final VariedadRemoteDataSource remoteDataSource;

  VariedadRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Variedad>> getAll() async {
    return remoteDataSource.getAll();
  }

  @override
  Future<List<Variedad>> getByFruta(int frutaId) async {
    return remoteDataSource.getByFruta(frutaId);
  }

  @override
  Future<Variedad> create(Variedad variedad) async {

    if (variedad.idFruta == null) {
      throw const AppException('Selecciona una fruta.');
    }

    final request = VariedadRequestModel.fromEntity(variedad);
    return remoteDataSource.create(request);
  }

  @override
  Future<Variedad> update(Variedad variedad) async {

    final id = variedad.id;
    if (id == null) {
      throw const AppException('No se encontró el ID de la variedad.');
    }

    if (variedad.idFruta == null) {
      throw const AppException('Selecciona una fruta.');
    }

    final request = VariedadRequestModel.fromEntity(variedad);
    return remoteDataSource.update(id, request: request);
  }

  @override
  Future<Variedad> changeStatus({required int id, required bool estado}) async {
    return remoteDataSource.changeStatus(id: id, estado: estado);
  }

}
