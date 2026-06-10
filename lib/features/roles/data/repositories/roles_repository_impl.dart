import '../../domain/entities/role.dart';
import '../../domain/repositories/roles_repository.dart';
import '../datasources/roles_remote_data_source.dart';
class RolesRepositoryImpl implements RolesRepository { final RolesRemoteDataSource remoteDataSource; RolesRepositoryImpl(this.remoteDataSource); @override Future<List<Role>> getRoles() => remoteDataSource.getRoles(); }
