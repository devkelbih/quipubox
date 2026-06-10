import '../../data/models/puesto_request_model.dart';
import '../entities/puesto.dart';
import '../repositories/puestos_repository.dart';
class CreatePuestoUseCase { final PuestoRepository repository; CreatePuestoUseCase(this.repository); Future<Puesto> call(PuestoRequestModel request) => repository.create(request); }
