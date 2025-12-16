// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupabaseUserDto _$SupabaseUserDtoFromJson(Map<String, dynamic> json) =>
    SupabaseUserDto(
      id: json['id'] as String,
      email: json['email'] as String?,
      userMetadata: json['user_metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$SupabaseUserDtoToJson(SupabaseUserDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'user_metadata': instance.userMetadata,
    };
