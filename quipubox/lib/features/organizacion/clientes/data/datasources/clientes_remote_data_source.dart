import 'package:quipubox/core/network/response_parser.dart';
import 'package:quipubox/features/organizacion/clientes/data/models/cliente_full_request_model.dart';

import '../../../../../core/network/api_client.dart';
import '../models/cliente_model.dart';
import '../models/cliente_page_model.dart';

class ClienteRemoteDataSource {
  final ApiClient apiClient;
  ClienteRemoteDataSource({required this.apiClient});
  Future<bool> changeStatus({required int id, required bool estado}) async {
    final response = await apiClient.patch(
      '/clientes/$id/estado',
      body: {'estado': estado},
    );

    final data = ResponseParser.extractObject(response);

    return data['estado'] == true;
  }

  Future<ClienteModel> create(ClienteFullRequestModel request) async {
    final response = await apiClient.post(
      '/clientes/full',
      body: request.toCreateJson(),
    );

    return ClienteModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<ClienteModel> update(
    int id, {
    required ClienteFullRequestModel request,
  }) async {
    final response = await apiClient.put(
      '/clientes/$id/full',
      body: request.toUpdateJson(),
    );

    return ClienteModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<List<ClienteModel>> getAll() async {
    // TODO: Temporal para selectores de carga. Sustituir por consulta por sede y
    // tipo de relación cuando la API los filtre antes de paginar, sin descargar todos.
    final response = await apiClient.get('/clientes/all');

    return ResponseParser.extractList(
      response,
    ).map(ClienteModel.fromJson).toList();
  }

  Future<ClientePageModel> getPage({
    int page = 1,
    int limit = 10,
    String buscar = '',
    bool? estado,
    String? tipoRelacion,
  }) async {
    final response = await apiClient.get(
      '/clientes',
      query: {
        'page': '$page',
        if (tipoRelacion != null) 'tipo_relacion': tipoRelacion,
        'limit': '$limit',
        'estado': estado == null ? 'todos' : '$estado',
        if (buscar.trim().isNotEmpty) 'buscar': buscar.trim(),
      },
    );
    return ClientePageModel.fromJson(ResponseParser.extractObject(response));
  }
}
