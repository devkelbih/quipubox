import '../../domain/entities/role.dart';
import '../../domain/repositories/roles_repository.dart';
import '../datasources/roles_remote_data_source.dart';

class RolesRepositoryImpl implements RolesRepository {
  final RolesRemoteDataSource remoteDataSource;
  RolesRepositoryImpl(this.remoteDataSource);
  @override
  Future<List<Role>> getAll() async {
    final models = await remoteDataSource.getAll();
    return models.map((e) => e.toEntity()).toList();
  }
}
