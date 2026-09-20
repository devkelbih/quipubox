import 'package:quipubox/features/lugares_operativos/data/models/lugar_operativo_request_model.dart';

import '../../domain/entities/lugar_operativo.dart';
import '../../domain/repositories/lugares_operativos_repository.dart';
import '../datasources/lugares_operativos_remote_data_source.dart';

class LugarOperativoRepositoryImpl implements LugarOperativoRepository {
  final LugarOperativoRemoteDataSource remoteDataSource;

  LugarOperativoRepositoryImpl({required this.remoteDataSource});
  @override
  Future<List<LugarOperativo>> getAll() async {
    final lugaresOperativos = await remoteDataSource.getAll();
    return lugaresOperativos.map((model) => model.toEntity()).toList();
  }

  @override
  Future<bool> changeStatus({required int id, required bool estado}) =>
      remoteDataSource.changeStatus(id: id, estado: estado);

  @override
  Future<LugarOperativo> create(LugarOperativo lugarOperativo) async {
    final request = LugarOperativoRequestModel.fromEntity(lugarOperativo);

    final model = await remoteDataSource.create(request);
    return model.toEntity();
  }

  @override
  Future<LugarOperativo> update(LugarOperativo lugarOperativo) async {
    final request = LugarOperativoRequestModel.fromEntity(lugarOperativo);

    final model = await remoteDataSource.update(lugarOperativo.id!, request);
    return model.toEntity();
  }
}
