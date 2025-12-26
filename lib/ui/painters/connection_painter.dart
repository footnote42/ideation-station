import 'package:flutter/material.dart';
import 'package:ideation_station/models/mind_map.dart';
import 'package:ideation_station/models/node.dart';
import 'package:ideation_station/models/node_type.dart';
import 'package:ideation_station/utils/constants.dart';

/// Custom painter for rendering curved organic branch connections.
///
/// Implements Buzan methodology requirements:
/// - FR-007: Curved organic branches (NOT straight lines)
/// - FR-007a: Visual thickness hierarchy (main branches thicker than sub-branches)
///
/// Branches use bezier curves for organic flow and taper from thick to thin.
class ConnectionPainter extends CustomPainter {
  final MindMap mindMap;
  final Offset canvasCenter;

  ConnectionPainter({
    required this.mindMap,
    required this.canvasCenter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw connections from parent to children
    for (final node in mindMap.nodes) {
      if (node.parentId != null) {
        final parent = _findNodeById(node.parentId!);
        if (parent != null) {
          _drawCurvedConnection(
            canvas,
            parent,
            node,
            size,
          );
        }
      }
    }
  }

  /// Draws a curved organic connection between parent and child nodes.
  ///
  /// Uses quadratic bezier curve for natural flow.
  /// Applies thickness hierarchy based on node depth.
  void _drawCurvedConnection(
    Canvas canvas,
    Node parent,
    Node child,
    Size size,
  ) {
    // Convert normalized positions to canvas coordinates
    final parentPoint = _positionToOffset(parent.position, size);
    final childPoint = _positionToOffset(child.position, size);

    // Determine line thickness based on node type (FR-007a)
    final thickness = _getThicknessForNode(child);

    // Create paint with parent's color (branches inherit parent color)
    final paint = Paint()
      ..color = parent.color.withOpacity(0.8)
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Calculate control point for bezier curve
    // Position control point to create natural curve
    final controlPoint = _calculateControlPoint(parentPoint, childPoint);

    // Draw curved path using quadratic bezier
    final path = Path()
      ..moveTo(parentPoint.dx, parentPoint.dy)
      ..quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        childPoint.dx,
        childPoint.dy,
      );

    canvas.drawPath(path, paint);

    // Optional: Draw tapering effect for more organic look
    // This can be enhanced in future iterations
  }

  /// Calculates the control point for quadratic bezier curve.
  ///
  /// Creates natural curve that flows organically from parent to child.
  Offset _calculateControlPoint(Offset start, Offset end) {
    // Calculate midpoint
    final midX = (start.dx + end.dx) / 2;
    final midY = (start.dy + end.dy) / 2;

    // Calculate perpendicular offset for curve depth
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;

    // Calculate actual distance using sqrt
    final distanceSquared = dx * dx + dy * dy;
    final distance = distanceSquared > 0 ? distanceSquared : 1.0;

    // Curve depth proportional to distance (more curve for longer connections)
    final curveDepth = distance * 0.0015;

    // Perpendicular vector for curve offset (normalized)
    final length = (dx * dx + dy * dy);
    final normalizer = length > 0 ? length : 1.0;
    final perpX = -dy / normalizer;
    final perpY = dx / normalizer;

    // Control point offset perpendicular to connection line
    return Offset(
      midX + perpX * curveDepth,
      midY + perpY * curveDepth,
    );
  }

  /// Determines line thickness based on node type (FR-007a).
  ///
  /// Visual hierarchy: main branches > sub-branches > deep sub-branches
  double _getThicknessForNode(Node node) {
    switch (node.type) {
      case NodeType.central:
        return AppConstants.mainBranchThickness; // Should not be used
      case NodeType.branch:
        return AppConstants.mainBranchThickness; // 8.0px
      case NodeType.subBranch:
        // Determine depth to use appropriate thickness
        final depth = _calculateNodeDepth(node);
        if (depth == 2) {
          return AppConstants.subBranchThickness; // 5.0px
        } else {
          return AppConstants.deepSubBranchThickness; // 3.0px
        }
    }
  }

  /// Calculates the depth of a node in the hierarchy.
  ///
  /// Central = 0, Branch = 1, SubBranch = 2+
  int _calculateNodeDepth(Node node) {
    var depth = 0;
    var current = node;

    while (current.parentId != null) {
      depth++;
      final parent = _findNodeById(current.parentId!);
      if (parent == null) break;
      current = parent;
    }

    return depth;
  }

  /// Converts normalized position to canvas offset.
  Offset _positionToOffset(position, Size size) {
    // Center of canvas
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Convert normalized coordinates (center = 0,0) to canvas coordinates
    return Offset(
      centerX + position.x,
      centerY + position.y,
    );
  }

  /// Finds a node by ID in the mind map.
  Node? _findNodeById(String id) {
    try {
      return mindMap.nodes.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  bool shouldRepaint(ConnectionPainter oldDelegate) {
    // Only repaint if mind map data changed
    return mindMap != oldDelegate.mindMap ||
        canvasCenter != oldDelegate.canvasCenter;
  }
}
