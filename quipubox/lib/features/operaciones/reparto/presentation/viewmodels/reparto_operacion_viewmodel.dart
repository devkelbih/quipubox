import '../../../../../core/state/base_state_viewmodel.dart';
import '../../domain/entities/distribucion_operacion.dart';
import '../../domain/usecases/get_distribucion_operacion.dart';

class RepartoOperacionViewModel extends BaseStateViewModel {
  final GetDistribucionOperacionUseCase getDistribucion;
  RepartoOperacionViewModel(this.getDistribucion);
  DistribucionOperacion? data;
  Future<void> load(int id) async {
    if (isLoading) return;
    final result = await run<DistribucionOperacion>(
      state: ViewModelActionState.loading,
      action: () => getDistribucion(id),
    );
    if (result != null) {
      data = result;
      notifyListeners();
    }
  }
}
