import '../../data/models/calidad_request_model.dart';
import '../entities/calidad.dart';
import '../repositories/calidades_repository.dart';
class UpdateCalidadUseCase { final CalidadRepository repository; UpdateCalidadUseCase(this.repository); Future<Calidad> call(int id, {required CalidadRequestModel request}) => repository.update(id, request: request); }
