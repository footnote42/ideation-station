import 'dart:math' as math;
import 'package:ideation_station/models/position.dart';
import 'package:ideation_station/utils/constants.dart';

/// Service for calculating node positions using radial layout algorithm.
///
/// Implements Buzan methodology requirement for radial structure where
/// branches emanate outward from central node in all directions.
class LayoutService {
  /// Calculates the radial position for a child node around its parent.
  ///
  /// Distributes children evenly in a circle around the parent node.
  /// Uses polar coordinates converted to Cartesian for positioning.
  ///
  /// Parameters:
  /// - [parentPosition]: The position of the parent node
  /// - [childIndex]: The index of this child (0-based)
  /// - [totalChildren]: Total number of children to distribute
  /// - [radius]: Distance from parent (defaults to centralNodeRadius from constants)
  ///
  /// Returns: [Position] for the child node in canvas coordinates
  Position radialPosition({
    required Position parentPosition,
    required int childIndex,
    required int totalChildren,
    double? radius,
  }) {
    // Use default radius if not specified
    final r = radius ?? AppConstants.centralNodeRadius;

    // Handle edge case of zero children
    if (totalChildren == 0) {
      return Position(
        x: parentPosition.x + r,
        y: parentPosition.y,
      );
    }

    // Calculate angle for this child
    // Distribute evenly around full circle (360 degrees)
    final angleStep = 360.0 / totalChildren;
    final angleDegrees = childIndex * angleStep;

    // Convert to radians for trigonometry
    final angleRadians = angleDegrees * math.pi / 180;

    // Calculate Cartesian coordinates using polar conversion
    // x = r * cos(θ), y = r * sin(θ)
    final x = parentPosition.x + (r * math.cos(angleRadians));
    final y = parentPosition.y + (r * math.sin(angleRadians));

    return Position(x: x, y: y);
  }

  /// Auto-positions all new children of a parent node.
  ///
  /// Only positions nodes that don't already have manual positions.
  /// Preserves spatial memory per Buzan methodology.
  List<Position> autoPositionChildren({
    required Position parentPosition,
    required int childCount,
    double? radius,
  }) {
    return List.generate(
      childCount,
      (index) => radialPosition(
        parentPosition: parentPosition,
        childIndex: index,
        totalChildren: childCount,
        radius: radius,
      ),
    );
  }
}
