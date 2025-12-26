import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

/// JSON converter for Flutter Color objects.
///
/// Serializes Color to/from integer value (ARGB format).
/// Example: Color(0xFFFF5733) <-> 4294923059
class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color color) => color.toARGB32();
}
