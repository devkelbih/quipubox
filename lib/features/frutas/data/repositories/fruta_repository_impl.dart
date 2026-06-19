import 'package:quipubox/core/exceptions/app_exception.dart';

import '../../domain/entities/fruta.dart';
import '../../domain/repositories/fruta_repository.dart';
import '../datasources/fruta_remote_data_source.dart';
import '../models/fruta_request_model.dart';

class FrutaRepositoryImpl implements FrutaRepository {
  final FrutaRemoteDataSource remoteDataSource;

  FrutaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Fruta>> getAll() async {
    return remoteDataSource.getAll();
  }

  @override
  Future<Fruta> create(Fruta fruta) async {
    final request = FrutaRequestModel.fromEntity(fruta);
    return remoteDataSource.create(request);
  }

  @override
  Future<Fruta> update(Fruta fruta) async {
    final id = fruta.id;
    if (id == null) {
      throw const AppException('No se encontró el ID de la fruta.');
    }

    final request = FrutaRequestModel.fromEntity(fruta);
    return remoteDataSource.update(id, request: request);
  }

  @override
  Future<Fruta> changeStatus({required int id, required bool estado}) async {
    return remoteDataSource.changeStatus(id: id, estado: estado);
  }
}
