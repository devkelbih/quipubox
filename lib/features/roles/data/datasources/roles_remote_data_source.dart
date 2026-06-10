import '../../../../core/network/api_client.dart';
import '../models/role_model.dart';
class RolesRemoteDataSource { final ApiClient apiClient; RolesRemoteDataSource(this.apiClient); Future<List<RoleModel>> getRoles() async => RoleModel.listFrom(await apiClient.get('/roles-usuarios')); }
