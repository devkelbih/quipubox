import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente_puesto.dart';
import 'package:quipubox/features/organizacion/clientes/domain/entities/cliente_sede.dart';

import '../entities/cliente.dart';

abstract class ClienteRepository {
  Future<List<Cliente>> getAll();
  Future<Cliente> create(Cliente cliente);
  Future<Cliente> update(Cliente cliente);
  Future<bool> changeStatus({required int id, required bool estado});

  Future<ClienteSede> addClienteSede(ClienteSede clienteSede);

  Future<ClienteSede> updateClienteSedeRelation(ClienteSede clienteSede);

  Future<ClientePuesto> addClientePuesto(ClientePuesto clientePuesto);
}
