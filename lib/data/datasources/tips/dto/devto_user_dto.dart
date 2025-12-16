import 'package:json_annotation/json_annotation.dart';

part 'devto_user_dto.g.dart';

@JsonSerializable()
class DevtoUserDto {
  final String? name;
  @JsonKey(name: 'username')
  final String? username;
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @JsonKey(name: 'profile_image_90')
  final String? profileImage90;

  DevtoUserDto({
    this.name,
    this.username,
    this.profileImage,
    this.profileImage90,
  });

  factory DevtoUserDto.fromJson(Map<String, dynamic> json) =>
      _$DevtoUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DevtoUserDtoToJson(this);
}

