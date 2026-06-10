import '../../data/models/fruta_request_model.dart';
import '../entities/fruta.dart';
import '../repositories/frutas_repository.dart';
class UpdateFrutaUseCase { final FrutaRepository repository; UpdateFrutaUseCase(this.repository); Future<Fruta> call(int id, {required FrutaRequestModel request}) => repository.update(id, request: request); }
