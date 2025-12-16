import 'package:json_annotation/json_annotation.dart';

part 'devto_tag_dto.g.dart';

@JsonSerializable()
class DevtoTagDto {
  final int? id;
  final String? name;
  @JsonKey(name: 'bg_color_hex')
  final String? bgColorHex;
  @JsonKey(name: 'text_color_hex')
  final String? textColorHex;

  DevtoTagDto({
    this.id,
    this.name,
    this.bgColorHex,
    this.textColorHex,
  });

  factory DevtoTagDto.fromJson(Map<String, dynamic> json) =>
      _$DevtoTagDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DevtoTagDtoToJson(this);
}

