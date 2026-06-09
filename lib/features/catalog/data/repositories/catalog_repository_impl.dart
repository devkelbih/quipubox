import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/catalog_item.dart';
import '../../domain/entities/catalog_module.dart';
import '../../domain/repositories/catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final ApiClient apiClient;

  CatalogRepositoryImpl(this.apiClient);

  @override
  Future<List<CatalogItem>> findAll(CatalogModule module) async {
    final response = await apiClient.get(module.getEndpoint);
    final list = _extractList(response);
    return list.map((e) => _toItem(module, e)).toList();
  }

  @override
  Future<CatalogItem> create(CatalogModule module, Map<String, dynamic> data) async {
    final payload = Map<String, dynamic>.from(data);
    payload.putIfAbsent('id_empresa', () => AppConfig.currentCompanyId);
    final response = await apiClient.post(module.postEndpoint, payload);
    return _toItem(module, _extractMap(response));
  }

  @override
  Future<CatalogItem> update(CatalogModule module, int id, Map<String, dynamic> data) async {
    final response = await apiClient.patch(module.patchEndpoint(id), data);
    return _toItem(module, _extractMap(response));
  }

  List<Map<String, dynamic>> _extractList(dynamic response) {
    if (response is List) {
      return response.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    if (response is Map<String, dynamic>) {
      for (final key in ['data', 'items', 'results']) {
        final value = response[key];
        if (value is List) {
          return value.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
        }
      }
      return [response];
    }
    return [];
  }

  Map<String, dynamic> _extractMap(dynamic response) {
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data is Map<String, dynamic>) return data;
      return response;
    }
    return {};
  }

  CatalogItem _toItem(CatalogModule module, Map<String, dynamic> json) {
    final idKey = module.idKeyResolver?.call(json) ?? _detectIdKey(json);
    return CatalogItem(
      id: _asInt(json[idKey]),
      idEmpresa: _asInt(json['id_empresa']) ?? AppConfig.currentCompanyId,
      title: module.titleBuilder(json),
      subtitle: module.subtitleBuilder(json),
      data: json,
    );
  }

  String _detectIdKey(Map<String, dynamic> json) {
    final keys = json.keys.where((e) => e.startsWith('id_')).toList();
    if (keys.isNotEmpty) return keys.first;
    return 'id';
  }

  int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}
