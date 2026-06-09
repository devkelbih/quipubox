import 'package:flutter/foundation.dart';

import '../../domain/entities/catalog_item.dart';
import '../../domain/entities/catalog_module.dart';
import '../../domain/usecases/get_catalog_items_usecase.dart';
import '../../domain/usecases/save_catalog_item_usecase.dart';

class CatalogViewModel extends ChangeNotifier {
  final GetCatalogItemsUseCase getItemsUseCase;
  final SaveCatalogItemUseCase saveItemUseCase;

  CatalogViewModel({
    required this.getItemsUseCase,
    required this.saveItemUseCase,
  });

  List<CatalogItem> items = [];
  bool isLoading = false;
  bool isSaving = false;
  bool isDeleting = false;
  String? errorMessage;

  Future<void> load(CatalogModule module) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      items = await getItemsUseCase(module);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> save(CatalogModule module, Map<String, dynamic> data, {int? id}) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      await saveItemUseCase(module, data, id: id);
      await load(module);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
