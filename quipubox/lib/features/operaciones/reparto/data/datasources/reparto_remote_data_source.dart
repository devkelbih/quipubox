import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/response_parser.dart';
import '../models/reparto_model.dart';

class RepartoRemoteDataSource {
  final ApiClient api;
  const RepartoRemoteDataSource(this.api);
  Future<List<RepartoModel>> getAll(Map<String, String> query) async =>
      ResponseParser.extractList(
        await api.get('/items-reparto', query: query),
      ).map(RepartoModel.new).toList();
  Future<RepartoModel> getById(int id) async => RepartoModel(
    ResponseParser.extractObject(await api.get('/items-reparto/$id')),
  );
  Future<List<RepartoModel>> getByDetalle(int id) async =>
      ResponseParser.extractList(
        await api.get('/items-reparto/detalle-carga/$id'),
      ).map(RepartoModel.new).toList();
  Future<void> create(String path, Map<String, dynamic> body) async {
    await api.post('/items-reparto$path', body: body);
  }

  Future<void> update(int id, Map<String, dynamic> body) async {
    await api.put('/items-reparto/$id', body: body, preserveNulls: true);
  }

  Future<void> delete(int id) async {
    await api.delete('/items-reparto/$id');
  }

  Future<List<RepartoLineaModel>> getLineas(int id) async =>
      ResponseParser.extractList(
        await api.get('/items-reparto/$id/detalle'),
      ).map(RepartoLineaModel.new).toList();
  Future<RepartoLineaModel> getLinea(int id) async => RepartoLineaModel(
    ResponseParser.extractObject(await api.get('/items-reparto/detalle/$id')),
  );
  Future<void> addLinea(int id, Map<String, dynamic> body) async {
    await api.post('/items-reparto/$id/detalle', body: body);
  }

  Future<void> updateLinea(int id, Map<String, dynamic> body) async {
    await api.put(
      '/items-reparto/detalle/$id',
      body: body,
      preserveNulls: true,
    );
  }

  Future<void> deleteLinea(int id) async {
    await api.delete('/items-reparto/detalle/$id');
  }
}
