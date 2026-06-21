import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class GetCachedUserUseCase {
  final AuthRepository repository;

  GetCachedUserUseCase(this.repository);

  Future<AppUser?> call() {
    return repository.getCachedUser();
  }
}