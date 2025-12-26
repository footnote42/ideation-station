import 'package:freezed_annotation/freezed_annotation.dart';

part 'node_symbol.freezed.dart';
part 'node_symbol.g.dart';

/// Predefined symbol types for visual meaning in mind maps.
///
/// Symbols add visual cues to enhance memory and meaning per Buzan methodology.
enum SymbolType {
  /// Star symbol - highlights important or favorite ideas
  star,

  /// Light bulb - indicates insights, innovations, or bright ideas
  lightbulb,

  /// Question mark - marks areas needing research or uncertainty
  question,

  /// Check mark - indicates completed items or validated concepts
  check,

  /// Warning/exclamation - highlights critical issues or urgent items
  warning,

  /// Heart - represents passion, enthusiasm, or emotional connection
  heart,

  /// Up arrow - indicates growth, increase, or positive direction
  arrowUp,

  /// Down arrow - indicates decrease, decline, or areas to reduce
  arrowDown,
}

/// Position where a symbol is displayed relative to a node.
enum SymbolPosition {
  /// Top-right corner of the node
  topRight,

  /// Bottom-left corner of the node
  bottomLeft,
}

/// A visual symbol attached to a mind map node.
///
/// Symbols provide quick visual cues without cluttering node text.
/// Multiple symbols can be attached to a single node.
@freezed
class NodeSymbol with _$NodeSymbol {
  const factory NodeSymbol({
    required SymbolType type,
    @Default(SymbolPosition.topRight) SymbolPosition position,
  }) = _NodeSymbol;

  factory NodeSymbol.fromJson(Map<String, dynamic> json) =>
      _$NodeSymbolFromJson(json);
}
