import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/auth_repository.dart';
class GetCurrentSessionUseCase { final AuthRepository repository; GetCurrentSessionUseCase(this.repository); Session? call() => repository.getCurrentSession(); }
