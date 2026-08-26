import 'package:flutter_post_app/core/storage/secure_storage.dart';

class AuthRepository {
  final SecureStorage _storage;

  AuthRepository(this._storage);

  Future<String?> getCachedToken() => _storage.read('access_token');

  Future flushData() => _storage.purge();
}
