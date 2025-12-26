import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'node_type.dart';
import 'position.dart';
import 'node_symbol.dart';
import '../utils/color_converter.dart';

part 'node.freezed.dart';
part 'node.g.dart';

/// A node in the mind map representing an idea, concept, or keyword.
///
/// Nodes form a hierarchical tree structure:
/// - One CENTRAL node at the root
/// - BRANCH nodes connect directly to central
/// - SUB_BRANCH nodes extend from branches (can nest indefinitely)
@freezed
class Node with _$Node {
  const factory Node({
    /// Unique identifier for this node
    required String id,

    /// Text content - ideally a single keyword (1-4 words recommended)
    required String text,

    /// Hierarchical type: CENTRAL, BRANCH, or SUB_BRANCH
    required NodeType type,

    /// Position on the canvas (normalized coordinates, center = 0,0)
    required Position position,

    /// Visual color for this node and its branch connection
    @ColorConverter() required Color color,

    /// Visual symbols attached to this node for quick meaning
    @Default([]) List<NodeSymbol> symbols,

    /// ID of parent node (null for central node)
    String? parentId,

    /// IDs of child nodes (empty for leaf nodes)
    @Default([]) List<String> childIds,
  }) = _Node;

  factory Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);
}
