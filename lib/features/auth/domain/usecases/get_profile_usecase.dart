import '../entities/authenticated_user.dart';
import '../repositories/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository repository;
  GetProfileUseCase(this.repository);
  Future<AuthenticatedUser> call() => repository.getProfile();
}
