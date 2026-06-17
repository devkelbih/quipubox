import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/core/network/network_checker.dart';

import '../../domain/entities/camion.dart';
import '../../domain/repositories/camiones_repository.dart';
import '../datasources/camiones_remote_data_source.dart';
import '../models/camion_request_model.dart';

class CamionRepositoryImpl implements CamionRepository {
  final CamionRemoteDataSource remoteDataSource;
  final NetworkChecker networkChecker;

  CamionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkChecker,
  });

  @override
  Future<List<Camion>> getAll() async {
    await _checkInternet();
    return remoteDataSource.getAll();
  }

  @override
  Future<Camion> create(Camion camion) async {
    await _checkInternet();

    final request = CamionRequestModel.fromEntity(camion);

    return remoteDataSource.create(request);
  }

  @override
  Future<Camion> update(Camion camion) async {
    await _checkInternet();

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
    await _checkInternet();

    return remoteDataSource.changeStatus(
      id: id,
      estado: estado,
    );
  }

  Future<void> _checkInternet() async {
    final hasInternet = await networkChecker.hasInternet();

    if (!hasInternet) {
      throw const AppException('No hay conexión a internet.');
    }
  }
}