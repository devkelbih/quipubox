import '../../data/models/sede_request_model.dart';
import '../entities/sede.dart';
import '../repositories/sedes_repository.dart';
class UpdateSedeUseCase { final SedeRepository repository; UpdateSedeUseCase(this.repository); Future<Sede> call(int id, {required SedeRequestModel request}) => repository.update(id, request: request); }
