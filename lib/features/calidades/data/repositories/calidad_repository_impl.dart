import 'package:quipubox/core/exceptions/app_exception.dart';

import '../../domain/entities/calidad.dart';
import '../../domain/repositories/calidad_repository.dart';
import '../datasources/calidad_remote_data_source.dart';
import '../models/calidad_request_model.dart';

class CalidadRepositoryImpl implements CalidadRepository {
  final CalidadRemoteDataSource remoteDataSource;

  CalidadRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Calidad>> getAll() async {
    return remoteDataSource.getAll();
  }

  @override
  Future<Calidad> create(Calidad calidad) async {
    final request = CalidadRequestModel.fromEntity(calidad);
    return remoteDataSource.create(request);
  }

  @override
  Future<Calidad> update(Calidad calidad) async {
    final id = calidad.id;
    if (id == null) {
      throw const AppException('No se encontró el ID de la calidad.');
    }

    final request = CalidadRequestModel.fromEntity(calidad);
    return remoteDataSource.update(id, request: request);
  }

  @override
  Future<Calidad> changeStatus({required int id, required bool estado}) async {
    return remoteDataSource.changeStatus(id: id, estado: estado);
  }
}
