import '../entities/catalog_item.dart';
import '../entities/catalog_module.dart';

abstract class CatalogRepository {
  Future<List<CatalogItem>> findAll(CatalogModule module);
  Future<CatalogItem> create(CatalogModule module, Map<String, dynamic> data);
  Future<CatalogItem> update(CatalogModule module, int id, Map<String, dynamic> data);
}
