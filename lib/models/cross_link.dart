import 'package:freezed_annotation/freezed_annotation.dart';

part 'cross_link.freezed.dart';
part 'cross_link.g.dart';

/// A cross-link connection between two non-adjacent nodes in the mind map.
///
/// Cross-links represent associative relationships that don't follow
/// the hierarchical tree structure. They're visualized as dashed/dotted
/// lines distinct from solid branch connections.
@freezed
class CrossLink with _$CrossLink {
  const factory CrossLink({
    /// Unique identifier for this cross-link
    required String id,

    /// ID of the source node
    required String sourceNodeId,

    /// ID of the target node
    required String targetNodeId,

    /// Optional label describing the relationship
    String? label,

    /// Timestamp when this cross-link was created
    required DateTime createdAt,
  }) = _CrossLink;

  factory CrossLink.fromJson(Map<String, dynamic> json) =>
      _$CrossLinkFromJson(json);
}
