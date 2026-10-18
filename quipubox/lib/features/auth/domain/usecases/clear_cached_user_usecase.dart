import '../repositories/auth_repository.dart';

class ClearCachedUserUseCase {
  final AuthRepository repository;

  ClearCachedUserUseCase(this.repository);

  Future<void> call() {
    return repository.clearCachedUser();
  }
}