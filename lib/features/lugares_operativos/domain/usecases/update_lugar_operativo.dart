import '../../data/models/lugar_operativo_request_model.dart';
import '../entities/lugar_operativo.dart';
import '../repositories/lugares_operativos_repository.dart';
class UpdateLugarOperativoUseCase { final LugarOperativoRepository repository; UpdateLugarOperativoUseCase(this.repository); Future<LugarOperativo> call(int id, {required LugarOperativoRequestModel request}) => repository.update(id, request: request); }
