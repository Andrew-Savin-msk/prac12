import 'package:prac12/core/models/account/user_account_model.dart';
import 'package:prac12/data/datasources/account/dto/supabase_user_dto.dart';

class SupabaseUserMapper {
  /// Маппинг SupabaseUserDto в UserAccount
  static UserAccount toUserAccount(SupabaseUserDto dto) {
    // Извлекаем full_name из user_metadata
    final fullName = dto.userMetadata?['full_name'] as String?;
    
    return UserAccount(
      id: dto.id,
      name: fullName ?? dto.email?.split('@').first ?? 'User',
      email: dto.email ?? '',
      password: '', // Пароль не возвращается из API
      avatarUrl: dto.userMetadata?['avatar_url'] as String?,
    );
  }
}

