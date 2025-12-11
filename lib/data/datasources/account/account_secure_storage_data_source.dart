// Data-слой: обёртка над flutter_secure_storage для работы с токенами авторизации аккаунта
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prac12/core/constants/secure_storage_keys.dart';
import 'package:prac12/core/models/account/auth_tokens.dart';

/// Data source для работы с токенами авторизации в Flutter Secure Storage
class AccountSecureStorageDataSource {
  final FlutterSecureStorage _storage;

  AccountSecureStorageDataSource() : _storage = const FlutterSecureStorage();

  /// Сохранить токены авторизации
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    String? userId,
  }) async {
    try {
      await _storage.write(
        key: SecureStorageKeys.accessToken,
        value: accessToken,
      );
      
      if (refreshToken != null) {
        await _storage.write(
          key: SecureStorageKeys.refreshToken,
          value: refreshToken,
        );
      }
      
      if (userId != null) {
        await _storage.write(
          key: SecureStorageKeys.userId,
          value: userId,
        );
      }
    } catch (e) {
      print('Ошибка при сохранении токенов в secure storage: $e');
    }
  }

  /// Прочитать токены авторизации
  Future<AuthTokens?> readTokens() async {
    try {
      final accessToken = await _storage.read(key: SecureStorageKeys.accessToken);
      
      if (accessToken == null) {
        return null;
      }
      
      final refreshToken = await _storage.read(key: SecureStorageKeys.refreshToken);
      final userId = await _storage.read(key: SecureStorageKeys.userId);
      
      return AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
      );
    } catch (e) {
      print('Ошибка при чтении токенов из secure storage: $e');
      return null;
    }
  }

  /// Очистить все токены
  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: SecureStorageKeys.accessToken);
      await _storage.delete(key: SecureStorageKeys.refreshToken);
      await _storage.delete(key: SecureStorageKeys.userId);
    } catch (e) {
      print('Ошибка при очистке токенов из secure storage: $e');
    }
  }
}
