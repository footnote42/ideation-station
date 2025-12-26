import 'package:freezed_annotation/freezed_annotation.dart';

import 'cross_link.dart';
import 'node.dart';

part 'mind_map.freezed.dart';
part 'mind_map.g.dart';

/// A complete mind map containing nodes, connections, and metadata.
///
/// Every mind map has exactly one central node with branches radiating outward.
/// Nodes form a tree structure via parent-child relationships, and cross-links
/// provide additional associative connections between non-adjacent nodes.
@freezed
class MindMap with _$MindMap {
  const factory MindMap({
    /// Unique identifier for this mind map
    required String id,

    /// User-friendly name for this mind map
    required String name,

    /// Timestamp when this mind map was created
    required DateTime createdAt,

    /// Timestamp of last modification
    required DateTime lastModifiedAt,

    /// The central node (required - every mind map has exactly one)
    required Node centralNode,

    /// All nodes in the mind map (includes central node and all branches)
    @Default([]) List<Node> nodes,

    /// Cross-link connections between non-adjacent nodes
    @Default([]) List<CrossLink> crossLinks,
  }) = _MindMap;

  factory MindMap.fromJson(Map<String, dynamic> json) =>
      _$MindMapFromJson(json);
}
