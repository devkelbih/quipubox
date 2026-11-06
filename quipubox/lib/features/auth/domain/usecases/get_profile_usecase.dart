import '../../../../core/exceptions/app_exception.dart';
import '../entities/authenticated_user.dart';
import '../repositories/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository repository;
  GetProfileUseCase(this.repository);
  Future<AuthenticatedUser> call() async {
    final profile = await repository.getProfile();
    if (profile.id <= 0 || profile.idEmpresa <= 0 || profile.idSede <= 0) {
      throw const AppException(
        'No se pudo cargar tu perfil completo. Intenta nuevamente.',
      );
    }
    return profile;
  }
}
