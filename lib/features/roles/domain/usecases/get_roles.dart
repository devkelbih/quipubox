import '../entities/role.dart';
import '../repositories/roles_repository.dart';
class GetRolesUseCase { final RolesRepository repository; GetRolesUseCase(this.repository); Future<List<Role>> call() => repository.getRoles(); }
