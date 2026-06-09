import 'package:flutter/foundation.dart';

import '../../../../core/config/app_config.dart';
import '../../data/company_repository.dart';
import '../../domain/entities/company.dart';

class CompanyViewModel extends ChangeNotifier {
  final CompanyRepository repository;

  CompanyViewModel(this.repository);

  Company? company;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadCurrentCompany() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      company = await repository.findById(AppConfig.currentCompanyId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
