import '../../domain/entities/camion.dart';
import '../../domain/repositories/camiones_repository.dart';
import '../datasources/camiones_remote_data_source.dart';
import '../models/camion_request_model.dart';
class CamionRepositoryImpl implements CamionRepository { final CamionRemoteDataSource remoteDataSource; CamionRepositoryImpl(this.remoteDataSource); @override Future<List<Camion>> getAll() => remoteDataSource.getAll(); @override Future<Camion> create(CamionRequestModel request) => remoteDataSource.create(request); @override Future<Camion> update(int id, {required CamionRequestModel request}) => remoteDataSource.update(id, request: request); @override Future<void> delete(int id) => remoteDataSource.delete(id); }
