import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/app_user_model.dart';

class AuthLocalDataSource {
  static const _cachedUserKey = 'auth_cached_user';

  final FlutterSecureStorage storage;

  const AuthLocalDataSource(this.storage);

  Future<AppUserModel?> getCachedUser() async {
    try {
      final raw = await storage.read(
        key: _cachedUserKey,
      );

      if (raw == null || raw.trim().isEmpty) {
        return null;
      }

      final decoded = jsonDecode(raw);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      return AppUserModel.fromJson(decoded,source: 'cache');
    } on Object {
      return null;
    }
  }

  Future<void> saveCachedUser(AppUserModel user) async {
    await storage.write(
      key: _cachedUserKey,
      value: jsonEncode(
        user.toJson(),
      ),
    );
  }

  Future<void> clearCachedUser() async {
    await storage.delete(
      key: _cachedUserKey,
    );
  }
}