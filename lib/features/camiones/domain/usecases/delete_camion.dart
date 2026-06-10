import '../repositories/camiones_repository.dart';
class DeleteCamionUseCase { final CamionRepository repository; DeleteCamionUseCase(this.repository); Future<void> call(int id) => repository.delete(id); }
