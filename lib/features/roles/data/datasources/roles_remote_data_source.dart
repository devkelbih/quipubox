import 'package:quipubox/core/network/response_parser.dart';

import '../../../../core/network/api_client.dart';
import '../models/role_model.dart';

class RolesRemoteDataSource {
  final ApiClient apiClient;
  RolesRemoteDataSource(this.apiClient);
  Future<List<RoleModel>> getAll() async {
    final response = await apiClient.get('/roles-usuarios');
    return ResponseParser.extractList(
      response,
    ).map(RoleModel.fromJson).toList();
  }
}
