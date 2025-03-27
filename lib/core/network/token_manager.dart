import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  final FlutterSecureStorage storage;
  String? _accessToken;
  String? _refreshToken;

  TokenManager(this.storage);

  Future<void> loadTokens() async {
    _accessToken = await storage.read(key: 'accessToken');
    _refreshToken = await storage.read(key: 'refreshToken');
  }

  Future<void> setAccessToken({
    required String accessToken,
  }) async {
    _accessToken = accessToken;
    await storage.write(key: 'accessToken', value: accessToken);
  }

  Future<void> setRefreshToken({
    required String refreshToken,
  }) async {
    _refreshToken = refreshToken;
    await storage.write(key: 'refreshToken', value: refreshToken);
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
  }

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
}
