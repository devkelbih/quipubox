enum CatalogFieldType { text, number, select, phone, email, url, booleanValue }

class CatalogField {
  final String key;
  final String label;
  final CatalogFieldType type;
  final bool required;
  final List<String> options;
  final int maxLines;

  const CatalogField({
    required this.key,
    required this.label,
    this.type = CatalogFieldType.text,
    this.required = false,
    this.options = const [],
    this.maxLines = 1,
  });
}
