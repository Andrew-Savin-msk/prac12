// Core-модель для представления токенов авторизации (техническая, для работы secure storage/репозитория)
/// Модель токенов авторизации для безопасного хранения
class AuthTokens {
  final String accessToken;
  final String? refreshToken;
  final String? userId;
  final String? userEmail;

  AuthTokens({
    required this.accessToken,
    this.refreshToken,
    this.userId,
    this.userEmail,
  });
}
