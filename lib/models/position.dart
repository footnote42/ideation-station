import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';
part 'position.g.dart';

/// Represents a position on the mind map canvas.
///
/// Uses normalized canvas coordinates where (0, 0) is the center of the canvas.
/// Positive x extends to the right, positive y extends downward.
@freezed
class Position with _$Position {
  const factory Position({
    required double x,
    required double y,
  }) = _Position;

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);

  /// Creates a Position at the canvas center (0, 0)
  factory Position.center() => const Position(x: 0, y: 0);
}
