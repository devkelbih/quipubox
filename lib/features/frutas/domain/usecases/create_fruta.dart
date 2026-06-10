import '../../data/models/fruta_request_model.dart';
import '../entities/fruta.dart';
import '../repositories/frutas_repository.dart';
class CreateFrutaUseCase { final FrutaRepository repository; CreateFrutaUseCase(this.repository); Future<Fruta> call(FrutaRequestModel request) => repository.create(request); }
