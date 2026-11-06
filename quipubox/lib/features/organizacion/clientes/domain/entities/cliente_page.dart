import 'cliente.dart';

class ClientePage {
  final List<Cliente> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const ClientePage({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });
}
