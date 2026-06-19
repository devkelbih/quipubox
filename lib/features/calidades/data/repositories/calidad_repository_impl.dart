import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/core/network/network_checker.dart';

import '../../domain/entities/calidad.dart';
import '../../domain/repositories/calidad_repository.dart';
import '../datasources/calidad_remote_data_source.dart';
import '../models/calidad_request_model.dart';

class CalidadRepositoryImpl implements CalidadRepository {
  final CalidadRemoteDataSource remoteDataSource;
  final NetworkChecker networkChecker;

  CalidadRepositoryImpl({
    required this.remoteDataSource,
    required this.networkChecker,
  });

  @override
  Future<List<Calidad>> getAll() async {
    await _checkInternet();
    return remoteDataSource.getAll();
  }

  @override
  Future<Calidad> create(Calidad calidad) async {
    await _checkInternet();
    final request = CalidadRequestModel.fromEntity(calidad);
    return remoteDataSource.create(request);
  }

  @override
  Future<Calidad> update(Calidad calidad) async {
    await _checkInternet();

    final id = calidad.id;
    if (id == null) {
      throw const AppException('No se encontró el ID de la calidad.');
    }

    final request = CalidadRequestModel.fromEntity(calidad);
    return remoteDataSource.update(id, request: request);
  }

  @override
  Future<Calidad> changeStatus({required int id, required bool estado}) async {
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
