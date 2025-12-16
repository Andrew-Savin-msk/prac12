// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devto_tag_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevtoTagDto _$DevtoTagDtoFromJson(Map<String, dynamic> json) => DevtoTagDto(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  bgColorHex: json['bg_color_hex'] as String?,
  textColorHex: json['text_color_hex'] as String?,
);

Map<String, dynamic> _$DevtoTagDtoToJson(DevtoTagDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bg_color_hex': instance.bgColorHex,
      'text_color_hex': instance.textColorHex,
    };
