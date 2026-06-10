import '../../data/models/variedad_request_model.dart';
import '../entities/variedad.dart';
import '../repositories/variedades_repository.dart';
class UpdateVariedadUseCase { final VariedadRepository repository; UpdateVariedadUseCase(this.repository); Future<Variedad> call(int id, {required VariedadRequestModel request}) => repository.update(id, request: request); }
