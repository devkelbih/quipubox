import '../entities/catalog_item.dart';
import '../entities/catalog_module.dart';
import '../repositories/catalog_repository.dart';

class GetCatalogItemsUseCase {
  final CatalogRepository repository;

  GetCatalogItemsUseCase(this.repository);

  Future<List<CatalogItem>> call(CatalogModule module) => repository.findAll(module);
}
