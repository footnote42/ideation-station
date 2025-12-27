import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideation_station/models/cross_link.dart';
import 'package:ideation_station/models/mind_map.dart';
import 'package:ideation_station/models/node.dart';
import 'package:ideation_station/models/node_symbol.dart';
import 'package:ideation_station/models/node_type.dart';
import 'package:ideation_station/models/position.dart';
import 'package:ideation_station/services/layout_service.dart';
import 'package:ideation_station/utils/constants.dart';
import 'package:uuid/uuid.dart';

/// State notifier for managing mind map state and operations.
///
/// Provides methods for:
/// - Creating central nodes
/// - Adding branch and sub-branch nodes
/// - Updating node properties
/// - Managing parent-child relationships
class MindMapNotifier extends StateNotifier<MindMap?> {
  final LayoutService _layoutService;
  final Uuid _uuid = const Uuid();

  MindMapNotifier({
    LayoutService? layoutService,
  })  : _layoutService = layoutService ?? LayoutService(),
        super(null);

  /// Creates a new mind map with a central node.
  ///
  /// Parameters:
  /// - [name]: Name of the mind map
  /// - [centralText]: Text for the central node
  /// - [centralColor]: Color for the central node (defaults to first palette color)
  void createMindMap({
    required String name,
    required String centralText,
    Color? centralColor,
  }) {
    final now = DateTime.now();
    final centralNode = Node(
      id: _uuid.v4(),
      text: centralText,
      type: NodeType.central,
      position: const Position(x: 0, y: 0),
      color: centralColor ?? AppConstants.colorPalette[0],
    );

    state = MindMap(
      id: _uuid.v4(),
      name: name,
      createdAt: now,
      lastModifiedAt: now,
      centralNode: centralNode,
      nodes: [centralNode],
    );
  }

  /// Adds a branch node connected to the central node.
  ///
  /// Auto-positions the branch radially around the central node.
  ///
  /// Parameters:
  /// - [text]: Text for the new branch node
  /// - [color]: Color for the branch (defaults to next palette color)
  ///
  /// Returns: ID of the created branch node
  String? addBranchNode({
    required String text,
    Color? color,
  }) {
    if (state == null) return null;

    final currentMap = state!;
    final centralNode = currentMap.centralNode;

    // Count existing branches to determine position and color
    final existingBranches = currentMap.nodes
        .where((n) => n.parentId == centralNode.id && n.type == NodeType.branch)
        .toList();

    // Auto-position using radial layout
    final position = _layoutService.radialPosition(
      parentPosition: centralNode.position,
      childIndex: existingBranches.length,
      totalChildren: existingBranches.length + 1,
    );

    // Auto-select color from palette (cycling through palette)
    final nodeColor = color ??
        AppConstants.colorPalette[existingBranches.length % AppConstants.colorPalette.length];

    // Create new branch node
    final branchId = _uuid.v4();
    final branchNode = Node(
      id: branchId,
      text: text,
      type: NodeType.branch,
      position: position,
      color: nodeColor,
      parentId: centralNode.id,
    );

    // Update central node's child list
    final updatedCentral = centralNode.copyWith(
      childIds: [...centralNode.childIds, branchId],
    );

    // Update state with new branch and updated central
    state = currentMap.copyWith(
      lastModifiedAt: DateTime.now(),
      centralNode: updatedCentral,
      nodes: [
        ...currentMap.nodes.where((n) => n.id != centralNode.id),
        updatedCentral,
        branchNode,
      ],
    );

    return branchId;
  }

  /// Adds a sub-branch node connected to a parent branch.
  ///
  /// Auto-positions the sub-branch radially around the parent.
  ///
  /// Parameters:
  /// - [parentId]: ID of the parent node (branch or sub-branch)
  /// - [text]: Text for the new sub-branch node
  /// - [color]: Color (defaults to parent's color per Buzan methodology)
  ///
  /// Returns: ID of the created sub-branch node
  String? addSubBranch({
    required String parentId,
    required String text,
    Color? color,
  }) {
    if (state == null) return null;

    final currentMap = state!;

    // Find parent node
    final parent = currentMap.nodes.firstWhere(
      (n) => n.id == parentId,
      orElse: () => throw ArgumentError('Parent node not found: $parentId'),
    );

    // Count existing children to determine position
    final existingChildren = currentMap.nodes
        .where((n) => n.parentId == parentId)
        .toList();

    // Auto-position using radial layout with smaller radius
    final position = _layoutService.radialPosition(
      parentPosition: parent.position,
      childIndex: existingChildren.length,
      totalChildren: existingChildren.length + 1,
      radius: AppConstants.centralNodeRadius * 0.66, // Smaller radius for sub-branches
    );

    // Inherit parent color by default (Buzan methodology FR-009)
    final nodeColor = color ?? parent.color;

    // Create new sub-branch node
    final subBranchId = _uuid.v4();
    final subBranchNode = Node(
      id: subBranchId,
      text: text,
      type: NodeType.subBranch,
      position: position,
      color: nodeColor,
      parentId: parentId,
    );

    // Update parent's child list
    final updatedParent = parent.copyWith(
      childIds: [...parent.childIds, subBranchId],
    );

    // Update state
    state = currentMap.copyWith(
      lastModifiedAt: DateTime.now(),
      nodes: [
        ...currentMap.nodes.where((n) => n.id != parentId),
        updatedParent,
        subBranchNode,
      ],
    );

    return subBranchId;
  }

  /// Updates node text.
  ///
  /// Parameters:
  /// - [nodeId]: ID of the node to update
  /// - [newText]: New text content
  void updateNodeText(String nodeId, String newText) {
    if (state == null) return;

    final currentMap = state!;
    final node = currentMap.nodes.firstWhere(
      (n) => n.id == nodeId,
      orElse: () => throw ArgumentError('Node not found: $nodeId'),
    );

    final updatedNode = node.copyWith(text: newText);

    // Update central node if it's being modified
    final updatedCentral = node.id == currentMap.centralNode.id
        ? updatedNode
        : currentMap.centralNode;

    state = currentMap.copyWith(
      lastModifiedAt: DateTime.now(),
      centralNode: updatedCentral,
      nodes: [
        ...currentMap.nodes.where((n) => n.id != nodeId),
        updatedNode,
      ],
    );
  }

  /// Updates node color and propagates to all descendants (FR-009).
  ///
  /// When a parent node's color changes, all children inherit that color recursively.
  ///
  /// Parameters:
  /// - [nodeId]: ID of the node to update
  /// - [newColor]: New color
  void updateNodeColor(String nodeId, Color newColor) {
    if (state == null) return;

    final currentMap = state!;
    final node = currentMap.nodes.firstWhere(
      (n) => n.id == nodeId,
      orElse: () => throw ArgumentError('Node not found: $nodeId'),
    );

    // Update the node and all its descendants with the new color
    final updatedNodes = _propagateColorToDescendants(
      currentMap.nodes,
      nodeId,
      newColor,
    );

    // Update central node if it's being modified
    final updatedCentral = node.id == currentMap.centralNode.id
        ? updatedNodes.firstWhere((n) => n.id == currentMap.centralNode.id)
        : currentMap.centralNode;

    state = currentMap.copyWith(
      lastModifiedAt: DateTime.now(),
      centralNode: updatedCentral,
      nodes: updatedNodes,
    );
  }

  /// Recursively propagate color to all descendants of a node.
  List<Node> _propagateColorToDescendants(
    List<Node> nodes,
    String nodeId,
    Color newColor,
  ) {
    final updatedNodes = <Node>[];
    final nodesToUpdate = <String>{nodeId};

    // Find all descendants recursively
    void findDescendants(String parentId) {
      for (final node in nodes) {
        if (node.parentId == parentId && !nodesToUpdate.contains(node.id)) {
          nodesToUpdate.add(node.id);
          findDescendants(node.id);
        }
      }
    }

    findDescendants(nodeId);

    // Update colors for all nodes
    for (final node in nodes) {
      if (nodesToUpdate.contains(node.id)) {
        updatedNodes.add(node.copyWith(color: newColor));
      } else {
        updatedNodes.add(node);
      }
    }

    return updatedNodes;
  }

  /// Updates node position (for drag-and-drop repositioning).
  ///
  /// Parameters:
  /// - [nodeId]: ID of the node to update
  /// - [newPosition]: New position on the canvas
  void updateNodePosition(String nodeId, Position newPosition) {
    if (state == null) return;

    final currentMap = state!;
    final node = currentMap.nodes.firstWhere(
      (n) => n.id == nodeId,
      orElse: () => throw ArgumentError('Node not found: $nodeId'),
    );

    final updatedNode = node.copyWith(position: newPosition);

    // Update central node if it's being modified
    final updatedCentral = node.id == currentMap.centralNode.id
        ? updatedNode
        : currentMap.centralNode;

    state = currentMap.copyWith(
      lastModifiedAt: DateTime.now(),
      centralNode: updatedCentral,
      nodes: [
        ...currentMap.nodes.where((n) => n.id != nodeId),
        updatedNode,
      ],
    );
  }

  /// Adds a cross-link (associative connection) between two nodes.
  ///
  /// Cross-links enable non-hierarchical associations between ideas.
  ///
  /// Parameters:
  /// - [sourceNodeId]: Starting node of the connection
  /// - [targetNodeId]: Ending node of the connection
  /// - [label]: Optional descriptive label for the relationship
  ///
  /// Returns: ID of the created cross-link
  ///
  /// Throws: ArgumentError if nodes don't exist or if creating a self-link
  String? addCrossLink({
    required String sourceNodeId,
    required String targetNodeId,
    String label = '',
  }) {
    if (state == null) return null;

    final currentMap = state!;

    // Validate source and target nodes exist
    final sourceExists = currentMap.nodes.any((n) => n.id == sourceNodeId);
    final targetExists = currentMap.nodes.any((n) => n.id == targetNodeId);

    if (!sourceExists) {
      throw ArgumentError('Source node not found: $sourceNodeId');
    }
    if (!targetExists) {
      throw ArgumentError('Target node not found: $targetNodeId');
    }

    // Prevent self-links
    if (sourceNodeId == targetNodeId) {
      throw ArgumentError('Cannot create cross-link from node to itself');
    }

    // Check for duplicate cross-links
    final duplicateExists = currentMap.crossLinks.any((link) =>
        (link.sourceNodeId == sourceNodeId &&
            link.targetNodeId == targetNodeId) ||
        (link.sourceNodeId == targetNodeId &&
            link.targetNodeId == sourceNodeId));

    if (duplicateExists) {
      throw ArgumentError(
          'Cross-link already exists between these nodes');
    }

    // Create new cross-link
    final crossLinkId = _uuid.v4();
    final crossLink = CrossLink(
      id: crossLinkId,
      sourceNodeId: sourceNodeId,
      targetNodeId: targetNodeId,
      label: label,
      createdAt: DateTime.now(),
    );

    // Update state
    state = currentMap.copyWith(
      lastModifiedAt: DateTime.now(),
      crossLinks: [...currentMap.crossLinks, crossLink],
    );

    return crossLinkId;
  }

  /// Deletes a cross-link by ID.
  ///
  /// Parameters:
  /// - [crossLinkId]: ID of the cross-link to delete
  void deleteCrossLink(String crossLinkId) {
    if (state == null) return;

    final currentMap = state!;

    state = currentMap.copyWith(
      lastModifiedAt: DateTime.now(),
      crossLinks:
          currentMap.crossLinks.where((link) => link.id != crossLinkId).toList(),
    );
  }

  /// Adds a symbol to a node.
  ///
  /// Nodes can have multiple symbols for enhanced visual expression.
  ///
  /// Parameters:
  /// - [nodeId]: ID of the node to add the symbol to
  /// - [symbol]: The symbol to add
  void addSymbolToNode(String nodeId, NodeSymbol symbol) {
    if (state == null) return;

    final currentMap = state!;
    final node = currentMap.nodes.firstWhere(
      (n) => n.id == nodeId,
      orElse: () => throw ArgumentError('Node not found: $nodeId'),
    );

    final updatedNode = node.copyWith(
      symbols: [...node.symbols, symbol],
    );

    // Update central node if it's being modified
    final updatedCentral = node.id == currentMap.centralNode.id
        ? updatedNode
        : currentMap.centralNode;

    state = currentMap.copyWith(
      lastModifiedAt: DateTime.now(),
      centralNode: updatedCentral,
      nodes: [
        ...currentMap.nodes.where((n) => n.id != nodeId),
        updatedNode,
      ],
    );
  }

  /// Removes a symbol from a node.
  ///
  /// Parameters:
  /// - [nodeId]: ID of the node to remove the symbol from
  /// - [symbol]: The symbol to remove
  void removeSymbolFromNode(String nodeId, NodeSymbol symbol) {
    if (state == null) return;

    final currentMap = state!;
    final node = currentMap.nodes.firstWhere(
      (n) => n.id == nodeId,
      orElse: () => throw ArgumentError('Node not found: $nodeId'),
    );

    final updatedNode = node.copyWith(
      symbols: node.symbols
          .where((s) => s.type != symbol.type || s.position != symbol.position)
          .toList(),
    );

    // Update central node if it's being modified
    final updatedCentral = node.id == currentMap.centralNode.id
        ? updatedNode
        : currentMap.centralNode;

    state = currentMap.copyWith(
      lastModifiedAt: DateTime.now(),
      centralNode: updatedCentral,
      nodes: [
        ...currentMap.nodes.where((n) => n.id != nodeId),
        updatedNode,
      ],
    );
  }

  /// Loads an existing mind map into state.
  void loadMindMap(MindMap mindMap) {
    state = mindMap;
  }

  /// Clears the current mind map.
  void clearMindMap() {
    state = null;
  }
}

/// Provider for mind map state management.
final mindMapProvider = StateNotifierProvider<MindMapNotifier, MindMap?>((ref) {
  return MindMapNotifier();
});
