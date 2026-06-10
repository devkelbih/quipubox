import '../../domain/entities/puesto.dart';
import '../../domain/repositories/puestos_repository.dart';
import '../datasources/puestos_remote_data_source.dart';
import '../models/puesto_request_model.dart';
class PuestoRepositoryImpl implements PuestoRepository { final PuestoRemoteDataSource remoteDataSource; PuestoRepositoryImpl(this.remoteDataSource); @override Future<List<Puesto>> getAll() => remoteDataSource.getAll(); @override Future<Puesto> create(PuestoRequestModel request) => remoteDataSource.create(request); @override Future<Puesto> update(int id, {required PuestoRequestModel request}) => remoteDataSource.update(id, request: request); @override Future<void> delete(int id) => remoteDataSource.delete(id); }
