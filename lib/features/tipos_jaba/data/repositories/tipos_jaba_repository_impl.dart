import '../../domain/entities/tipos_jaba.dart';
import '../../domain/repositories/tipos_jaba_repository.dart';
import '../datasources/tipos_jaba_remote_data_source.dart';
import '../models/tipos_jaba_request_model.dart';
class TipoJabaRepositoryImpl implements TipoJabaRepository { final TipoJabaRemoteDataSource remoteDataSource; TipoJabaRepositoryImpl(this.remoteDataSource); @override Future<List<TipoJaba>> getAll() => remoteDataSource.getAll(); @override Future<TipoJaba> create(TipoJabaRequestModel request) => remoteDataSource.create(request); @override Future<TipoJaba> update(int id, {required TipoJabaRequestModel request}) => remoteDataSource.update(id, request: request); @override Future<void> delete(int id) => remoteDataSource.delete(id); }
