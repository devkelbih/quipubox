import '../../data/models/tipos_jaba_request_model.dart';
import '../entities/tipos_jaba.dart';
import '../repositories/tipos_jaba_repository.dart';
class UpdateTipoJabaUseCase { final TipoJabaRepository repository; UpdateTipoJabaUseCase(this.repository); Future<TipoJaba> call(int id, {required TipoJabaRequestModel request}) => repository.update(id, request: request); }
