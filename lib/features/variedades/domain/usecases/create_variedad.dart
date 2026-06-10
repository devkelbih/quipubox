import '../../data/models/variedad_request_model.dart';
import '../entities/variedad.dart';
import '../repositories/variedades_repository.dart';
class CreateVariedadUseCase { final VariedadRepository repository; CreateVariedadUseCase(this.repository); Future<Variedad> call(VariedadRequestModel request) => repository.create(request); }
