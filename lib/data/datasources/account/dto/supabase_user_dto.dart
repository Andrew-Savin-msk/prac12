import 'package:json_annotation/json_annotation.dart';

part 'supabase_user_dto.g.dart';

@JsonSerializable()
class SupabaseUserDto {
  final String id;
  final String? email;
  
  @JsonKey(name: 'user_metadata')
  final Map<String, dynamic>? userMetadata;

  SupabaseUserDto({
    required this.id,
    this.email,
    this.userMetadata,
  });

  factory SupabaseUserDto.fromJson(Map<String, dynamic> json) =>
      _$SupabaseUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SupabaseUserDtoToJson(this);
}

