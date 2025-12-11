// Data-слой: обёртка над flutter_secure_storage для работы с токенами авторизации аккаунта
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prac12/core/constants/secure_storage_keys.dart';
import 'package:prac12/core/models/account/auth_tokens.dart';
import 'package:prac12/core/models/account/user_account_model.dart';

/// Data source для работы с токенами авторизации в Flutter Secure Storage
class AccountSecureStorageDataSource {
  final FlutterSecureStorage _storage;

  AccountSecureStorageDataSource() : _storage = const FlutterSecureStorage();

  /// Сохранить токены авторизации
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    String? userId,
    String? userEmail,
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
      
      if (userEmail != null) {
        await _storage.write(
          key: SecureStorageKeys.userEmail,
          value: userEmail,
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
      final userEmail = await _storage.read(key: SecureStorageKeys.userEmail);
      
      return AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
        userEmail: userEmail,
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
      await _storage.delete(key: SecureStorageKeys.userEmail);
      await _storage.delete(key: SecureStorageKeys.userData);
    } catch (e) {
      print('Ошибка при очистке токенов из secure storage: $e');
    }
  }

  /// Прочитать email пользователя
  Future<String?> readUserEmail() async {
    try {
      return await _storage.read(key: SecureStorageKeys.userEmail);
    } catch (e) {
      print('Ошибка при чтении email из secure storage: $e');
      return null;
    }
  }

  /// Сохранить полные данные пользователя в secure storage
  Future<void> saveUserData(UserAccount user) async {
    try {
      final userDataJson = jsonEncode({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'avatarUrl': user.avatarUrl,
      });
      
      await _storage.write(
        key: SecureStorageKeys.userData,
        value: userDataJson,
      );
    } catch (e) {
      print('Ошибка при сохранении данных пользователя в secure storage: $e');
    }
  }

  /// Прочитать полные данные пользователя из secure storage
  Future<UserAccount?> readUserData() async {
    try {
      final userDataJson = await _storage.read(key: SecureStorageKeys.userData);
      
      if (userDataJson == null) {
        return null;
      }
      
      final userData = jsonDecode(userDataJson) as Map<String, dynamic>;
      
      return UserAccount(
        id: userData['id'] as String,
        name: userData['name'] as String,
        email: userData['email'] as String,
        password: userData['password'] as String,
        avatarUrl: userData['avatarUrl'] as String?,
      );
    } catch (e) {
      print('Ошибка при чтении данных пользователя из secure storage: $e');
      return null;
    }
  }
}
