import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/auth_repository.dart';

class GetAuthStateChangesUseCase {
  final AuthRepository repository;

  const GetAuthStateChangesUseCase(this.repository);

  Stream<AuthState> call() => repository.authStateChanges;
}
