import '../entities/cliente_page.dart';
import '../repositories/clientes_repository.dart';

class GetClientesPageUseCase {
  final ClienteRepository repository;
  const GetClientesPageUseCase({required this.repository});

  Future<ClientePage> call({
    int page = 1,
    int limit = 10,
    String buscar = '',
    bool? estado,
    String? tipoRelacion,
  }) => repository.getPage(
    page: page,
    limit: limit,
    buscar: buscar.trim(),
    estado: estado,
    tipoRelacion: tipoRelacion,
  );
}
