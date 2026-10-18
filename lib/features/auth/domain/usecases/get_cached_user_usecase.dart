import '../entities/authenticated_user.dart';
import '../repositories/auth_repository.dart';

class GetCachedUserUseCase {
  final AuthRepository repository;

  GetCachedUserUseCase(this.repository);

  Future<AuthenticatedUser?> call() {
    return repository.getCachedUser();
  }
}