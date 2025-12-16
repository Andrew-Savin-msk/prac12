// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devto_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevtoUserDto _$DevtoUserDtoFromJson(Map<String, dynamic> json) => DevtoUserDto(
  name: json['name'] as String?,
  username: json['username'] as String?,
  profileImage: json['profile_image'] as String?,
  profileImage90: json['profile_image_90'] as String?,
);

Map<String, dynamic> _$DevtoUserDtoToJson(DevtoUserDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'profile_image': instance.profileImage,
      'profile_image_90': instance.profileImage90,
    };
