import '../../data/models/sede_request_model.dart';
import '../entities/sede.dart';
import '../repositories/sedes_repository.dart';
class CreateSedeUseCase { final SedeRepository repository; CreateSedeUseCase(this.repository); Future<Sede> call(SedeRequestModel request) => repository.create(request); }
