import 'package:json_annotation/json_annotation.dart';
import 'package:prac12/data/datasources/account/dto/supabase_user_dto.dart';

part 'supabase_auth_response_dto.g.dart';

@JsonSerializable()
class SupabaseAuthResponseDto {
  @JsonKey(name: 'access_token')
  final String? accessToken;
  
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  
  @JsonKey(name: 'expires_in')
  final int? expiresIn;
  
  @JsonKey(name: 'token_type')
  final String? tokenType;
  
  final SupabaseUserDto? user;

  SupabaseAuthResponseDto({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.tokenType,
    this.user,
  });

  factory SupabaseAuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SupabaseAuthResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SupabaseAuthResponseDtoToJson(this);
}

