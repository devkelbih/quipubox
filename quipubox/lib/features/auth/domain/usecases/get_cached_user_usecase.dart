import '../entities/authenticated_user.dart';
import '../repositories/auth_repository.dart';

class GetCachedUserUseCase {
  final AuthRepository repository;

  GetCachedUserUseCase(this.repository);

  Future<AuthenticatedUser?> call() async {
    final profile = await repository.getCachedUser();
    if (profile == null ||
        profile.id <= 0 ||
        profile.idEmpresa <= 0 ||
        profile.idSede <= 0) {
      return null;
    }
    return profile;
  }
}
