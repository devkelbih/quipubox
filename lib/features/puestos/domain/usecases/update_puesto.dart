import '../../data/models/puesto_request_model.dart';
import '../entities/puesto.dart';
import '../repositories/puestos_repository.dart';
class UpdatePuestoUseCase { final PuestoRepository repository; UpdatePuestoUseCase(this.repository); Future<Puesto> call(int id, {required PuestoRequestModel request}) => repository.update(id, request: request); }
