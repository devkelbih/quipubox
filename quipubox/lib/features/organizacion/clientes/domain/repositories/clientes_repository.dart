import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente_puesto.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente_sede.dart';

import '../entities/cliente.dart';
import '../entities/cliente_page.dart';

abstract class ClienteRepository {
  Future<List<Cliente>> getAll();
  Future<ClientePage> getPage({
    int page = 1,
    int limit = 10,
    String buscar = '',
    bool? estado,
    String? tipoRelacion,
  });
  Future<Cliente> create(Cliente cliente);
  Future<Cliente> update(Cliente cliente);
  Future<bool> changeStatus({required int id, required bool estado});

  Future<ClienteSede> addClienteSede(ClienteSede clienteSede);

  Future<ClienteSede> updateClienteSedeRelation(ClienteSede clienteSede);

  Future<ClientePuesto> addClientePuesto(ClientePuesto clientePuesto);
}
