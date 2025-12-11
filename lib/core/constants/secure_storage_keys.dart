/// Константы ключей для Flutter Secure Storage
class SecureStorageKeys {
  /// Ключ для сохранения access token
  static const String accessToken = 'secure_access_token';
  
  /// Ключ для сохранения refresh token
  static const String refreshToken = 'secure_refresh_token';
  
  /// Ключ для сохранения user ID
  static const String userId = 'secure_user_id';
  
  /// Ключ для сохранения email пользователя (для восстановления сессии)
  static const String userEmail = 'secure_user_email';
  
  /// Ключ для сохранения полных данных пользователя (JSON)
  static const String userData = 'secure_user_data';
  
  SecureStorageKeys._();
}
