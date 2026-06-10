import '../../domain/entities/lugar_operativo.dart';
import '../../domain/repositories/lugares_operativos_repository.dart';
import '../datasources/lugares_operativos_remote_data_source.dart';
import '../models/lugar_operativo_request_model.dart';
class LugarOperativoRepositoryImpl implements LugarOperativoRepository { final LugarOperativoRemoteDataSource remoteDataSource; LugarOperativoRepositoryImpl(this.remoteDataSource); @override Future<List<LugarOperativo>> getAll() => remoteDataSource.getAll(); @override Future<LugarOperativo> create(LugarOperativoRequestModel request) => remoteDataSource.create(request); @override Future<LugarOperativo> update(int id, {required LugarOperativoRequestModel request}) => remoteDataSource.update(id, request: request); @override Future<void> delete(int id) => remoteDataSource.delete(id); }
