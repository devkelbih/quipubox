import '../../domain/entities/fruta.dart';
import '../../domain/repositories/frutas_repository.dart';
import '../datasources/frutas_remote_data_source.dart';
import '../models/fruta_request_model.dart';
class FrutaRepositoryImpl implements FrutaRepository { final FrutaRemoteDataSource remoteDataSource; FrutaRepositoryImpl(this.remoteDataSource); @override Future<List<Fruta>> getAll() => remoteDataSource.getAll(); @override Future<Fruta> create(FrutaRequestModel request) => remoteDataSource.create(request); @override Future<Fruta> update(int id, {required FrutaRequestModel request}) => remoteDataSource.update(id, request: request); @override Future<void> delete(int id) => remoteDataSource.delete(id); }
