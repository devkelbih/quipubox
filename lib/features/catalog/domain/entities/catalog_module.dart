import 'catalog_field.dart';

class CatalogModule {
  final String title;
  final String route;
  final String getEndpoint;
  final String postEndpoint;
  final String Function(int id) patchEndpoint;
  final List<CatalogField> fields;
  final String Function(Map<String, dynamic> json) titleBuilder;
  final String Function(Map<String, dynamic> json) subtitleBuilder;
  final String? Function(Map<String, dynamic> json)? idKeyResolver;

  const CatalogModule({
    required this.title,
    required this.route,
    required this.getEndpoint,
    required this.postEndpoint,
    required this.patchEndpoint,
    required this.fields,
    required this.titleBuilder,
    required this.subtitleBuilder,
    this.idKeyResolver,
  });
}
