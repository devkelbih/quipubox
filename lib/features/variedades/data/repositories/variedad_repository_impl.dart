import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/core/network/network_checker.dart';

import '../../domain/entities/variedad.dart';
import '../../domain/repositories/variedad_repository.dart';
import '../datasources/variedad_remote_data_source.dart';
import '../models/variedad_request_model.dart';

class VariedadRepositoryImpl implements VariedadRepository {
  final VariedadRemoteDataSource remoteDataSource;
  final NetworkChecker networkChecker;

  VariedadRepositoryImpl({
    required this.remoteDataSource,
    required this.networkChecker,
  });

  @override
  Future<List<Variedad>> getAll() async {
    await _checkInternet();
    return remoteDataSource.getAll();
  }

  @override
  Future<List<Variedad>> getByFruta(int frutaId) async {
    await _checkInternet();
    return remoteDataSource.getByFruta(frutaId);
  }

  @override
  Future<Variedad> create(Variedad variedad) async {
    await _checkInternet();

    if (variedad.idFruta == null) {
      throw const AppException('Selecciona una fruta.');
    }

    final request = VariedadRequestModel.fromEntity(variedad);
    return remoteDataSource.create(request);
  }

  @override
  Future<Variedad> update(Variedad variedad) async {
    await _checkInternet();

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
    await _checkInternet();
    return remoteDataSource.changeStatus(id: id, estado: estado);
  }

  Future<void> _checkInternet() async {
    final hasInternet = await networkChecker.hasInternet();

    if (!hasInternet) {
      throw const AppException('No hay conexión a internet.');
    }
  }
}
