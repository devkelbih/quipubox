import '../entities/catalog_item.dart';
import '../entities/catalog_module.dart';
import '../repositories/catalog_repository.dart';

class SaveCatalogItemUseCase {
  final CatalogRepository repository;

  SaveCatalogItemUseCase(this.repository);

  Future<CatalogItem> call(CatalogModule module, Map<String, dynamic> data, {int? id}) {
    if (id == null) return repository.create(module, data);
    return repository.update(module, id, data);
  }
}
