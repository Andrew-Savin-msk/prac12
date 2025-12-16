import 'package:prac12/core/models/account/auth_tokens.dart';
import 'package:prac12/data/datasources/account/dto/supabase_auth_response_dto.dart';
import 'package:prac12/data/datasources/account/dto/supabase_user_dto.dart';

class SupabaseAuthMapper {
  /// Маппинг ответа Supabase Auth в AuthTokens
  static AuthTokens toAuthTokens(SupabaseAuthResponseDto dto) {
    return AuthTokens(
      accessToken: dto.accessToken ?? '',
      refreshToken: dto.refreshToken,
      userId: dto.user?.id,
      userEmail: dto.user?.email,
    );
  }
  
  /// Получить данные пользователя из ответа signup (если есть)
  static SupabaseUserDto? getUserFromResponse(SupabaseAuthResponseDto dto) {
    return dto.user;
  }
}

