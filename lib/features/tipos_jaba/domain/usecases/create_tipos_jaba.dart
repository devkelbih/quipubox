import '../../data/models/tipos_jaba_request_model.dart';
import '../entities/tipos_jaba.dart';
import '../repositories/tipos_jaba_repository.dart';
class CreateTipoJabaUseCase { final TipoJabaRepository repository; CreateTipoJabaUseCase(this.repository); Future<TipoJaba> call(TipoJabaRequestModel request) => repository.create(request); }
