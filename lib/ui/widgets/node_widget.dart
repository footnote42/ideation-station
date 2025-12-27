import 'package:flutter/material.dart';
import 'package:ideation_station/models/node.dart';
import 'package:ideation_station/models/node_symbol.dart';
import 'package:ideation_station/models/node_type.dart';
import 'package:ideation_station/models/position.dart';
import 'package:ideation_station/utils/constants.dart';

/// Widget for rendering a single mind map node.
///
/// Displays node text with visual styling based on node type (central, branch, sub-branch).
/// Handles tap events with <100ms response time per performance budget (SC-002).
/// Supports drag-and-drop repositioning when isDraggable is true.
/// Supports symbol attachment via long-press gesture.
class NodeWidget extends StatelessWidget {
  final Node node;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final bool isDraggable;
  final Function(Position)? onDragEnd;

  const NodeWidget({
    super.key,
    required this.node,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.isDraggable = false,
    this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    final nodeWidget = RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
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

  /// Build symbol widgets positioned around the node
  List<Widget> _buildSymbols() {
    return node.symbols.map((symbol) {
      final iconData = _getSymbolIcon(symbol.type);
      final iconColor = _getSymbolColor(symbol.type);
      final offset = _getSymbolOffset(symbol.position);

      return Positioned(
        top: offset.dy,
        left: offset.dx,
        right: offset.dx < 0 ? null : offset.dx,
        bottom: offset.dy < 0 ? null : offset.dy,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: iconColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.all(4),
          child: Icon(
            iconData,
            size: 14,
            color: iconColor,
          ),
        ),
      );
    }).toList();
  }

  /// Get icon data for a symbol type
  IconData _getSymbolIcon(SymbolType type) {
    switch (type) {
      case SymbolType.star:
        return Icons.star;
      case SymbolType.lightbulb:
        return Icons.lightbulb;
      case SymbolType.question:
        return Icons.help;
      case SymbolType.check:
        return Icons.check_circle;
      case SymbolType.warning:
        return Icons.warning;
      case SymbolType.heart:
        return Icons.favorite;
      case SymbolType.arrowUp:
        return Icons.arrow_upward;
      case SymbolType.arrowDown:
        return Icons.arrow_downward;
    }
  }

  /// Get color for a symbol type
  Color _getSymbolColor(SymbolType type) {
    switch (type) {
      case SymbolType.star:
        return Colors.amber;
      case SymbolType.lightbulb:
        return Colors.yellow.shade700;
      case SymbolType.question:
        return Colors.blue;
      case SymbolType.check:
        return Colors.green;
      case SymbolType.warning:
        return Colors.orange;
      case SymbolType.heart:
        return Colors.red;
      case SymbolType.arrowUp:
        return Colors.green;
      case SymbolType.arrowDown:
        return Colors.red.shade700;
    }
  }

  /// Get offset for symbol position
  Offset _getSymbolOffset(SymbolPosition position) {
    const symbolOffset = 4.0; // Distance from corner
    switch (position) {
      case SymbolPosition.topRight:
        return const Offset(symbolOffset, -symbolOffset);
      case SymbolPosition.bottomLeft:
        return const Offset(-symbolOffset, symbolOffset);
    }
  }
}
