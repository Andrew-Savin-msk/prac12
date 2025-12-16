// Data-слой: обёртка над flutter_secure_storage для работы с токенами авторизации аккаунта
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prac12/core/constants/secure_storage_keys.dart';
import 'package:prac12/core/models/account/auth_tokens.dart';
import 'package:prac12/core/models/account/user_account_model.dart';

/// Data source для работы с токенами авторизации в Flutter Secure Storage
class AccountSecureStorageDataSource {
  final FlutterSecureStorage _storage;

  AccountSecureStorageDataSource() : _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    mOptions: MacOsOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      groupId: '6GPYCRZNS3.com.example.prac12', // Должно соответствовать keychain-access-groups в entitlements
    ),
  );

  /// Сохранить токены авторизации
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    String? userId,
    String? userEmail,
  }) async {
    print('=== AccountSecureStorageDataSource.saveTokens START ===');
    print('Access token length: ${accessToken.length}');
    print('Refresh token: ${refreshToken != null ? "exists (${refreshToken.length} chars)" : "null"}');
    print('User ID: $userId');
    print('User email: $userEmail');
    try {
      print('Writing access token to secure storage...');
      await _storage.write(
        key: SecureStorageKeys.accessToken,
        value: accessToken,
      );
      print('Access token written');
      
      if (refreshToken != null) {
        print('Writing refresh token to secure storage...');
        await _storage.write(
          key: SecureStorageKeys.refreshToken,
          value: refreshToken,
        );
        print('Refresh token written');
      }
      
      if (userId != null) {
        print('Writing user ID to secure storage...');
        await _storage.write(
          key: SecureStorageKeys.userId,
          value: userId,
        );
        print('User ID written');
      }
      
      if (userEmail != null) {
        print('Writing user email to secure storage...');
        await _storage.write(
          key: SecureStorageKeys.userEmail,
          value: userEmail,
        );
        print('User email written');
      }
      print('=== AccountSecureStorageDataSource.saveTokens SUCCESS ===');
    } catch (e, stackTrace) {
      print('ERROR при сохранении токенов в secure storage: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Прочитать токены авторизации
  Future<AuthTokens?> readTokens() async {
    print('=== AccountSecureStorageDataSource.readTokens START ===');
    try {
      print('Reading access token from secure storage...');
      final accessToken = await _storage.read(key: SecureStorageKeys.accessToken);
      print('Access token read: ${accessToken != null ? "exists (${accessToken.length} chars)" : "null"}');
      
      if (accessToken == null) {
        print('Access token is null, returning null');
        print('=== AccountSecureStorageDataSource.readTokens NULL ===');
        return null;
      }
      
      print('Reading refresh token from secure storage...');
      final refreshToken = await _storage.read(key: SecureStorageKeys.refreshToken);
      print('Refresh token read: ${refreshToken != null ? "exists" : "null"}');
      
      print('Reading user ID from secure storage...');
      final userId = await _storage.read(key: SecureStorageKeys.userId);
      print('User ID read: $userId');
      
      print('Reading user email from secure storage...');
      final userEmail = await _storage.read(key: SecureStorageKeys.userEmail);
      print('User email read: $userEmail');
      
      final tokens = AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
        userEmail: userEmail,
      );
      print('=== AccountSecureStorageDataSource.readTokens SUCCESS ===');
      return tokens;
    } catch (e, stackTrace) {
      print('ERROR при чтении токенов из secure storage: $e');
      print('Stack trace: $stackTrace');
      print('=== AccountSecureStorageDataSource.readTokens ERROR ===');
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
