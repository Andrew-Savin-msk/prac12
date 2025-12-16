import 'package:prac12/core/models/tips/tip_tag_model.dart';
import 'package:prac12/data/datasources/tips/dto/devto_tag_dto.dart';

class DevtoTagMapper {
  static TipTag toDomain(DevtoTagDto dto) {
    return TipTag(
      id: dto.id,
      name: dto.name ?? 'Unknown',
      bgColorHex: dto.bgColorHex,
      textColorHex: dto.textColorHex,
    );
  }
}

