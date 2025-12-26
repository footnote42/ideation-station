import 'dart:ui';
import 'package:json_annotation/json_annotation.dart';

/// JSON converter for Flutter Offset objects.
///
/// Serializes Offset to/from Map with 'dx' and 'dy' keys.
/// Example: Offset(10.0, 20.0) <-> {"dx": 10.0, "dy": 20.0}
class OffsetConverter implements JsonConverter<Offset, Map<String, dynamic>> {
  const OffsetConverter();

  @override
  Offset fromJson(Map<String, dynamic> json) {
    return Offset(
      (json['dx'] as num).toDouble(),
      (json['dy'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(Offset offset) {
    return {
      'dx': offset.dx,
      'dy': offset.dy,
    };
  }
}
