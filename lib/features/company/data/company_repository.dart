import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../domain/entities/company.dart';

class CompanyRepository {
  final ApiClient apiClient;

  CompanyRepository(this.apiClient);

  Future<Company> findById(int id) async {
    final response = await apiClient.get(ApiEndpoints.empresaById(id));
    final json = response is Map<String, dynamic> && response['data'] is Map<String, dynamic>
        ? response['data'] as Map<String, dynamic>
        : response as Map<String, dynamic>;
    return Company.fromJson(json);
  }
}
