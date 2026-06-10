import '../../data/models/calidad_request_model.dart';
import '../entities/calidad.dart';
import '../repositories/calidades_repository.dart';
class CreateCalidadUseCase { final CalidadRepository repository; CreateCalidadUseCase(this.repository); Future<Calidad> call(CalidadRequestModel request) => repository.create(request); }
