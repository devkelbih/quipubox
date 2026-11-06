import '../../domain/entities/cliente_page.dart';
import 'cliente_model.dart';

class ClientePageModel {
  final List<ClienteModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const ClientePageModel({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory ClientePageModel.fromJson(Map<String, dynamic> json) =>
      ClientePageModel(
        items: (json['data'] as List)
            .map(
              (item) =>
                  ClienteModel.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList(),
        total: int.parse('${json['total']}'),
        page: int.parse('${json['page']}'),
        limit: int.parse('${json['limit']}'),
        totalPages: int.parse('${json['totalPages']}'),
      );

  ClientePage toEntity() => ClientePage(
    items: items.map((item) => item.toEntity()).toList(),
    total: total,
    page: page,
    limit: limit,
    totalPages: totalPages,
  );
}
