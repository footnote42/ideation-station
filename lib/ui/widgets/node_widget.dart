import 'package:flutter/material.dart';
import 'package:ideation_station/models/node.dart';
import 'package:ideation_station/models/node_type.dart';
import 'package:ideation_station/models/position.dart';
import 'package:ideation_station/utils/constants.dart';

/// Widget for rendering a single mind map node.
///
/// Displays node text with visual styling based on node type (central, branch, sub-branch).
/// Handles tap events with <100ms response time per performance budget (SC-002).
/// Supports drag-and-drop repositioning when isDraggable is true.
class NodeWidget extends StatelessWidget {
  final Node node;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isDraggable;
  final Function(Position)? onDragEnd;

  const NodeWidget({
    super.key,
    required this.node,
    this.onTap,
    this.isSelected = false,
    this.isDraggable = false,
    this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    final nodeWidget = RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            child: Container(
              constraints: BoxConstraints(
                minWidth: AppConstants.minTapTargetSize,
                minHeight: AppConstants.minTapTargetSize,
              ),
              padding: _getPadding(),
              decoration: BoxDecoration(
                color: node.color.withValues(alpha: 0.15),
                border: Border.all(
                  color: isSelected
                      ? node.color.withValues(alpha: 1.0)
                      : node.color.withValues(alpha: 0.6),
                  width: _getBorderWidth(),
                ),
                borderRadius: BorderRadius.circular(_getBorderRadius()),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: node.color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Node text
                  Center(
                    child: Text(
                      node.text,
                      style: TextStyle(
                        fontSize: _getFontSize(),
                        fontWeight: _getFontWeight(),
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  // Symbols (rendered in later user stories)
                  if (node.symbols.isNotEmpty) ..._buildSymbols(),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Wrap in Draggable if enabled
    if (isDraggable && onDragEnd != null) {
      return Draggable<String>(
        data: node.id,
        feedback: Material(
          color: Colors.transparent,
          child: Opacity(
            opacity: 0.7,
            child: nodeWidget,
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: nodeWidget,
        ),
        onDragEnd: (details) {
          // Convert screen coordinates to canvas position
          // The position is relative to the canvas center
          final screenCenter = MediaQueryData.fromView(View.of(context)).size.center(Offset.zero);
          final canvasPosition = Position(
            x: details.offset.dx - screenCenter.dx,
            y: details.offset.dy - screenCenter.dy,
          );
          onDragEnd!(canvasPosition);
        },
        child: nodeWidget,
      );
    }

    return nodeWidget;
  }

  /// Get padding based on node type
  EdgeInsets _getPadding() {
    switch (node.type) {
      case NodeType.central:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
      case NodeType.branch:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case NodeType.subBranch:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    }
  }

  /// Get border radius based on node type
  double _getBorderRadius() {
    switch (node.type) {
      case NodeType.central:
        return 16.0;
      case NodeType.branch:
        return 12.0;
      case NodeType.subBranch:
        return 8.0;
    }
  }

  /// Get border width based on node type (central node has thicker border)
  double _getBorderWidth() {
    switch (node.type) {
      case NodeType.central:
        return 3.0;
      case NodeType.branch:
        return 2.0;
      case NodeType.subBranch:
        return 1.5;
    }
  }

  /// Get font size based on node type
  double _getFontSize() {
    switch (node.type) {
      case NodeType.central:
        return 18.0;
      case NodeType.branch:
        return 16.0;
      case NodeType.subBranch:
        return 14.0;
    }
  }

  /// Get font weight based on node type
  FontWeight _getFontWeight() {
    switch (node.type) {
      case NodeType.central:
        return FontWeight.bold;
      case NodeType.branch:
        return FontWeight.w600;
      case NodeType.subBranch:
        return FontWeight.normal;
    }
  }

  /// Build symbol widgets (placeholder for User Story 3)
  List<Widget> _buildSymbols() {
    // Symbol rendering will be implemented in User Story 3
    return [];
  }
}
