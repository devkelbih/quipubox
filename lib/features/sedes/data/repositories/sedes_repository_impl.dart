import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../domain/entities/sede.dart';
import '../../domain/repositories/sedes_repository.dart';
import '../datasources/sedes_remote_data_source.dart';
import '../models/sede_request_model.dart';

class SedeRepositoryImpl implements SedeRepository {
  final SedeRemoteDataSource remoteDataSource;
  final NetworkChecker networkChecker;

  SedeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkChecker,
  });

  @override
  Future<List<Sede>> getAll() async {
    await _checkInternet();
    return remoteDataSource.getAll();
  }

  @override
  Future<Sede> create(Sede sede) async {
    await _checkInternet();

    final request = SedeRequestModel.fromEntity(sede);

    return remoteDataSource.create(request);
  }

  @override
  Future<Sede> update(Sede sede) async {
    await _checkInternet();
    final id = sede.id;
    if (id == null) {
      throw const AppException('No se encontró el ID de la sede.');
    }
    final request = SedeRequestModel.fromEntity(sede);
    return remoteDataSource.update(id, request: request);
  }

  @override
  Future<Sede> changeStatus({required int id, required bool estado}) async {
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
