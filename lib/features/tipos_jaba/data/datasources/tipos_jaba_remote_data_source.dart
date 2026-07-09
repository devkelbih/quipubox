import 'package:quipubox/core/network/response_parser.dart';

import '../../../../core/network/api_client.dart';
import '../models/tipos_jaba_model.dart';
import '../models/tipos_jaba_request_model.dart';

class TipoJabaRemoteDataSource {
  final ApiClient apiClient;
  TipoJabaRemoteDataSource(this.apiClient);

  Future<List<TipoJabaModel>> getAll() async{
    final response = await apiClient.get('/tipos-jaba');
    return ResponseParser.extractList(response)
        .map((e) => TipoJabaModel.fromJson(e))
        .toList();
  }

  Future<TipoJabaModel> create(TipoJabaRequestModel request) async{
    final response = await apiClient.post(
      '/tipos-jaba',
      body: request.toCreateJson(),
    );
    return TipoJabaModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<TipoJabaModel> update(
    int id, {
    required TipoJabaRequestModel request,
  }) async{
    final response = await apiClient.put(
      '/tipos-jaba/$id',
      body: request.toUpdateJson(),
    );
    return TipoJabaModel.fromJson(ResponseParser.extractObject(response));
  }

  Future<bool> changeStatus({
    required int id,
    required bool estado,
  }) async {
    final response = await apiClient.patch(
      '/tipos-jaba/$id/estado',
      body: {'estado': estado},
    );
    final data = ResponseParser.extractObject(response);
    return data['estado'] == true;
  }
}
