class CatalogItem {
  final int? id;
  final int idEmpresa;
  final String title;
  final String subtitle;
  final Map<String, dynamic> data;

  const CatalogItem({
    required this.id,
    required this.idEmpresa,
    required this.title,
    required this.subtitle,
    required this.data,
  });
}
