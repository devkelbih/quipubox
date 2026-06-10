import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository repository;
  GetProfileUseCase(this.repository);
  Future<AppUser> call() => repository.getProfile();
}
