import '../../domain/entities/calidad.dart';
import '../../domain/repositories/calidades_repository.dart';
import '../datasources/calidades_remote_data_source.dart';
import '../models/calidad_request_model.dart';
class CalidadRepositoryImpl implements CalidadRepository { final CalidadRemoteDataSource remoteDataSource; CalidadRepositoryImpl(this.remoteDataSource); @override Future<List<Calidad>> getAll() => remoteDataSource.getAll(); @override Future<Calidad> create(CalidadRequestModel request) => remoteDataSource.create(request); @override Future<Calidad> update(int id, {required CalidadRequestModel request}) => remoteDataSource.update(id, request: request); @override Future<void> delete(int id) => remoteDataSource.delete(id); }
