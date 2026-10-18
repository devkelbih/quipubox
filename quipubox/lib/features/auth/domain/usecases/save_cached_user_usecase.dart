import '../entities/authenticated_user.dart';
import '../repositories/auth_repository.dart';

class SaveCachedUserUseCase {
  final AuthRepository repository;

  SaveCachedUserUseCase(this.repository);

  Future<void> call(AuthenticatedUser user) {
    return repository.saveCachedUser(user);
  }
}