import 'package:quipubox/features/puestos/data/datasources/puestos_remote_data_source.dart';
import 'package:quipubox/features/puestos/data/models/puesto_request_model.dart';
import 'package:quipubox/features/puestos/domain/entities/puesto.dart';
import 'package:quipubox/features/puestos/domain/repositories/puestos_repository.dart';

class PuestoRepositoryImpl implements PuestoRepository {
  final PuestoRemoteDataSource remoteDataSource;

  PuestoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> changeStatus({required int id, required bool estado}) =>
      remoteDataSource.changeStatus(id: id, estado: estado);

  @override
  Future<Puesto> create(Puesto puesto) async {
    final request = PuestoRequestModel.fromEntity(puesto);
    final model = await remoteDataSource.create(request);
    return model.toEntity();
  }

  @override
  Future<List<Puesto>> getAll() async {
    final model = await remoteDataSource.getAll();
    return model.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Puesto> update(Puesto puesto) async {
    final request = PuestoRequestModel.fromEntity(puesto);
    final model = await remoteDataSource.update(puesto.id!, request: request);
    return model.toEntity();
  }
}
