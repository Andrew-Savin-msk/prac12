// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_auth_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupabaseAuthResponseDto _$SupabaseAuthResponseDtoFromJson(
  Map<String, dynamic> json,
) => SupabaseAuthResponseDto(
  accessToken: json['access_token'] as String?,
  refreshToken: json['refresh_token'] as String?,
  expiresIn: (json['expires_in'] as num?)?.toInt(),
  tokenType: json['token_type'] as String?,
  user: json['user'] == null
      ? null
      : SupabaseUserDto.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SupabaseAuthResponseDtoToJson(
  SupabaseAuthResponseDto instance,
) => <String, dynamic>{
  'access_token': instance.accessToken,
  'refresh_token': instance.refreshToken,
  'expires_in': instance.expiresIn,
  'token_type': instance.tokenType,
  'user': instance.user,
};
