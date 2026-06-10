import '../../domain/entities/variedad.dart';
import '../../domain/repositories/variedades_repository.dart';
import '../datasources/variedades_remote_data_source.dart';
import '../models/variedad_request_model.dart';
class VariedadRepositoryImpl implements VariedadRepository { final VariedadRemoteDataSource remoteDataSource; VariedadRepositoryImpl(this.remoteDataSource); @override Future<List<Variedad>> getAll() => remoteDataSource.getAll(); @override Future<Variedad> create(VariedadRequestModel request) => remoteDataSource.create(request); @override Future<Variedad> update(int id, {required VariedadRequestModel request}) => remoteDataSource.update(id, request: request); @override Future<void> delete(int id) => remoteDataSource.delete(id); }
