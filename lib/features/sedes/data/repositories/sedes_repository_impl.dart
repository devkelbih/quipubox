import '../../domain/entities/sede.dart';
import '../../domain/repositories/sedes_repository.dart';
import '../datasources/sedes_remote_data_source.dart';
import '../models/sede_request_model.dart';
class SedeRepositoryImpl implements SedeRepository { final SedeRemoteDataSource remoteDataSource; SedeRepositoryImpl(this.remoteDataSource); @override Future<List<Sede>> getAll() => remoteDataSource.getAll(); @override Future<Sede> create(SedeRequestModel request) => remoteDataSource.create(request); @override Future<Sede> update(int id, {required SedeRequestModel request}) => remoteDataSource.update(id, request: request); @override Future<void> delete(int id) => remoteDataSource.delete(id); }
