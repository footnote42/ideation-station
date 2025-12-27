import 'package:flutter/material.dart';
import 'package:ideation_station/models/mind_map.dart';
import 'package:ideation_station/models/node.dart';

/// Custom painter for rendering cross-links (associative connections).
///
/// Cross-links use dashed/dotted lines to visually distinguish them from
/// hierarchical branch connections (which use solid curves).
class CrossLinkPainter extends CustomPainter {
  final MindMap mindMap;
  final Offset canvasCenter;
  final bool showArrows;
  final bool showLabels;

  CrossLinkPainter({
    required this.mindMap,
    required this.canvasCenter,
    this.showArrows = true,
    this.showLabels = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final crossLink in mindMap.crossLinks) {
      // Find source and target nodes
      final sourceNode = _findNodeById(crossLink.sourceNodeId);
      final targetNode = _findNodeById(crossLink.targetNodeId);

      if (sourceNode != null && targetNode != null) {
        _drawCrossLink(
          canvas,
          sourceNode,
          targetNode,
          size,
          crossLink.label ?? '',
        );
      }
    }
  }

  /// Draws a dashed cross-link line between two nodes
  void _drawCrossLink(
    Canvas canvas,
    Node source,
    Node target,
    Size size,
    String label,
  ) {
    // Convert normalized positions to canvas coordinates
    final sourcePoint = _positionToOffset(source.position, size);
    final targetPoint = _positionToOffset(target.position, size);

    // Create dashed line paint
    final paint = Paint()
      ..color = Colors.grey[600]!.withValues(alpha: 0.7)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw dashed line
    _drawDashedLine(
      canvas,
      sourcePoint,
      targetPoint,
      paint,
      dashLength: 8.0,
      spaceLength: 4.0,
    );

    // Draw arrow if enabled
    if (showArrows) {
      _drawArrow(canvas, sourcePoint, targetPoint, paint);
    }

    // Draw label if enabled and label exists
    if (showLabels && label.isNotEmpty) {
      _drawLabel(canvas, sourcePoint, targetPoint, label);
    }
  }

  /// Draws a dashed line from start to end
  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint, {
    required double dashLength,
    required double spaceLength,
  }) {
    final path = Path();
    final distance = (end - start).distance;
    final unitVector = (end - start) / distance;

    double currentDistance = 0;
    bool drawing = true;

    while (currentDistance < distance) {
      final segmentLength = drawing ? dashLength : spaceLength;
      final nextDistance = (currentDistance + segmentLength).clamp(0.0, distance);

      final segmentStart = start + unitVector * currentDistance;
      final segmentEnd = start + unitVector * nextDistance;

      if (drawing) {
        path.moveTo(segmentStart.dx, segmentStart.dy);
        path.lineTo(segmentEnd.dx, segmentEnd.dy);
      }

      currentDistance = nextDistance;
      drawing = !drawing;
    }

    canvas.drawPath(path, paint);
  }

  /// Draws an arrow at the end of the cross-link
  void _drawArrow(Canvas canvas, Offset start, Offset end, Paint paint) {
    final arrowSize = 10.0;
    final direction = (end - start).direction;

    final arrowPath = Path();
    arrowPath.moveTo(end.dx, end.dy);
    arrowPath.lineTo(
      end.dx - arrowSize * 0.866 * (direction - 0.5).abs(),
      end.dy - arrowSize * 0.5,
    );
    arrowPath.lineTo(
      end.dx - arrowSize * 0.866 * (direction - 0.5).abs(),
      end.dy + arrowSize * 0.5,
    );
    arrowPath.close();

    canvas.drawPath(
      arrowPath,
      Paint()
        ..color = paint.color
        ..style = PaintingStyle.fill,
    );
  }

  /// Draws a label at the midpoint of the cross-link
  void _drawLabel(Canvas canvas, Offset start, Offset end, String label) {
    final midpoint = Offset(
      (start.dx + end.dx) / 2,
      (start.dy + end.dy) / 2,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 12,
          backgroundColor: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        midpoint.dx - textPainter.width / 2,
        midpoint.dy - textPainter.height / 2,
      ),
    );
  }

  /// Converts normalized position to canvas offset
  Offset _positionToOffset(position, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    return Offset(
      centerX + position.x,
      centerY + position.y,
    );
  }

  /// Finds a node by ID
  Node? _findNodeById(String id) {
    try {
      return mindMap.nodes.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  bool shouldRepaint(CrossLinkPainter oldDelegate) {
    return mindMap != oldDelegate.mindMap ||
        canvasCenter != oldDelegate.canvasCenter ||
        showArrows != oldDelegate.showArrows ||
        showLabels != oldDelegate.showLabels;
  }
}
