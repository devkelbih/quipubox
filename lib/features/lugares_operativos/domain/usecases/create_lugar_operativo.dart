import '../../data/models/lugar_operativo_request_model.dart';
import '../entities/lugar_operativo.dart';
import '../repositories/lugares_operativos_repository.dart';
class CreateLugarOperativoUseCase { final LugarOperativoRepository repository; CreateLugarOperativoUseCase(this.repository); Future<LugarOperativo> call(LugarOperativoRequestModel request) => repository.create(request); }
