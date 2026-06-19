import 'package:quipubox/core/exceptions/app_exception.dart';
import 'package:quipubox/core/network/network_checker.dart';

import '../../domain/entities/fruta.dart';
import '../../domain/repositories/fruta_repository.dart';
import '../datasources/fruta_remote_data_source.dart';
import '../models/fruta_request_model.dart';

class FrutaRepositoryImpl implements FrutaRepository {
  final FrutaRemoteDataSource remoteDataSource;
  final NetworkChecker networkChecker;

  FrutaRepositoryImpl({
    required this.remoteDataSource,
    required this.networkChecker,
  });

  @override
  Future<List<Fruta>> getAll() async {
    await _checkInternet();
    return remoteDataSource.getAll();
  }

  @override
  Future<Fruta> create(Fruta fruta) async {
    await _checkInternet();
    final request = FrutaRequestModel.fromEntity(fruta);
    return remoteDataSource.create(request);
  }

  @override
  Future<Fruta> update(Fruta fruta) async {
    await _checkInternet();

    final id = fruta.id;
    if (id == null) {
      throw const AppException('No se encontró el ID de la fruta.');
    }

    final request = FrutaRequestModel.fromEntity(fruta);
    return remoteDataSource.update(id, request: request);
  }

  @override
  Future<Fruta> changeStatus({required int id, required bool estado}) async {
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
