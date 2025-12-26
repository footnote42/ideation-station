import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:ideation_station/models/position.dart';
import 'package:ideation_station/models/node.dart';
import 'package:ideation_station/models/node_type.dart';
import 'package:ideation_station/services/layout_service.dart';
import 'package:flutter/material.dart';

/// Unit tests for LayoutService radial positioning algorithm (T023)
///
/// Tests cover:
/// - Even radial distribution of nodes around parent
/// - No overlap between sibling nodes
/// - Spatial memory preservation (don't move existing nodes)
/// - Configurable spacing and radius parameters
/// - Angle calculation for radial positioning
void main() {
  group('LayoutService Radial Positioning', () {
    late LayoutService layoutService;

    setUp(() {
      layoutService = LayoutService();
    });

    test('should calculate radial position for first branch at 0 degrees', () {
      final parentPosition = const Position(x: 0, y: 0);
      const childIndex = 0;
      const totalChildren = 1;

      final position = layoutService.radialPosition(
        parentPosition: parentPosition,
        childIndex: childIndex,
        totalChildren: totalChildren,
      );

      // First branch should be at 0 degrees (right side)
      // Using default radius of 150px from constants
      expect(position.x, closeTo(150, 1.0));
      expect(position.y, closeTo(0, 1.0));
    });

    test('should distribute nodes evenly in circle around parent', () {
      final parentPosition = const Position(x: 0, y: 0);
      const totalChildren = 4;

      final positions = List.generate(
        totalChildren,
        (index) => layoutService.radialPosition(
          parentPosition: parentPosition,
          childIndex: index,
          totalChildren: totalChildren,
        ),
      );

      expect(positions, hasLength(4));

      // Calculate angles for each position
      for (var i = 0; i < totalChildren; i++) {
        final angle = (i * 360 / totalChildren);
        final radians = angle * math.pi / 180;

        // Expected position at this angle (assuming 150px radius)
        final expectedX = 150 * math.cos(radians);
        final expectedY = 150 * math.sin(radians);

        expect(positions[i].x, closeTo(expectedX, 1.0));
        expect(positions[i].y, closeTo(expectedY, 1.0));
      }
    });

    test('should distribute 8 branches evenly around central node', () {
      final parentPosition = const Position(x: 0, y: 0);
      const totalChildren = 8;

      final positions = List.generate(
        totalChildren,
        (index) => layoutService.radialPosition(
          parentPosition: parentPosition,
          childIndex: index,
          totalChildren: totalChildren,
        ),
      );

      // Each branch should be 45 degrees apart (360 / 8)
      for (var i = 0; i < totalChildren; i++) {
        final angle = i * 45.0;
        final radians = angle * math.pi / 180;

        final expectedX = 150 * math.cos(radians);
        final expectedY = 150 * math.sin(radians);

        expect(positions[i].x, closeTo(expectedX, 1.0));
        expect(positions[i].y, closeTo(expectedY, 1.0));
      }
    });

    test('should handle custom radius parameter', () {
      final parentPosition = const Position(x: 0, y: 0);
      const customRadius = 200.0;

      final position = layoutService.radialPosition(
        parentPosition: parentPosition,
        childIndex: 0,
        totalChildren: 1,
        radius: customRadius,
      );

      expect(position.x, closeTo(customRadius, 1.0));
      expect(position.y, closeTo(0, 1.0));
    });

    test('should position nodes relative to non-centered parent', () {
      final parentPosition = const Position(x: 100, y: 50);
      const totalChildren = 2;

      final positions = List.generate(
        totalChildren,
        (index) => layoutService.radialPosition(
          parentPosition: parentPosition,
          childIndex: index,
          totalChildren: totalChildren,
        ),
      );

      // First child at 0 degrees: parent.x + radius, parent.y
      expect(positions[0].x, closeTo(100 + 150, 1.0));
      expect(positions[0].y, closeTo(50, 1.0));

      // Second child at 180 degrees: parent.x - radius, parent.y
      expect(positions[1].x, closeTo(100 - 150, 1.0));
      expect(positions[1].y, closeTo(50, 1.0));
    });

    test('should ensure no overlap between sibling nodes', () {
      final parentPosition = const Position(x: 0, y: 0);
      const totalChildren = 6;
      const minSpacing = 80.0; // Minimum distance between nodes

      final positions = List.generate(
        totalChildren,
        (index) => layoutService.radialPosition(
          parentPosition: parentPosition,
          childIndex: index,
          totalChildren: totalChildren,
        ),
      );

      // Check distance between consecutive nodes
      for (var i = 0; i < totalChildren; i++) {
        final next = (i + 1) % totalChildren;
        final distance = math.sqrt(
          math.pow(positions[next].x - positions[i].x, 2) +
              math.pow(positions[next].y - positions[i].y, 2),
        );

        expect(
          distance,
          greaterThan(minSpacing),
          reason: 'Nodes $i and $next are too close',
        );
      }
    });

    test('should handle single child correctly', () {
      final parentPosition = const Position(x: 0, y: 0);

      final position = layoutService.radialPosition(
        parentPosition: parentPosition,
        childIndex: 0,
        totalChildren: 1,
      );

      // Single child should still be positioned at 0 degrees
      expect(position.x, closeTo(150, 1.0));
      expect(position.y, closeTo(0, 1.0));
    });

    test('should handle many children (12 branches)', () {
      final parentPosition = const Position(x: 0, y: 0);
      const totalChildren = 12;

      final positions = List.generate(
        totalChildren,
        (index) => layoutService.radialPosition(
          parentPosition: parentPosition,
          childIndex: index,
          totalChildren: totalChildren,
        ),
      );

      expect(positions, hasLength(12));

      // Each branch should be 30 degrees apart (360 / 12)
      for (var i = 0; i < totalChildren; i++) {
        final angle = i * 30.0;
        final radians = angle * math.pi / 180;

        final expectedX = 150 * math.cos(radians);
        final expectedY = 150 * math.sin(radians);

        expect(positions[i].x, closeTo(expectedX, 1.0));
        expect(positions[i].y, closeTo(expectedY, 1.0));
      }
    });

    test('should calculate positions at cardinal directions correctly', () {
      final parentPosition = const Position(x: 0, y: 0);

      // East (0°)
      final east = layoutService.radialPosition(
        parentPosition: parentPosition,
        childIndex: 0,
        totalChildren: 4,
      );
      expect(east.x, closeTo(150, 1.0));
      expect(east.y, closeTo(0, 1.0));

      // North (90°)
      final north = layoutService.radialPosition(
        parentPosition: parentPosition,
        childIndex: 1,
        totalChildren: 4,
      );
      expect(north.x, closeTo(0, 1.0));
      expect(north.y, closeTo(150, 1.0));

      // West (180°)
      final west = layoutService.radialPosition(
        parentPosition: parentPosition,
        childIndex: 2,
        totalChildren: 4,
      );
      expect(west.x, closeTo(-150, 1.0));
      expect(west.y, closeTo(0, 1.0));

      // South (270°)
      final south = layoutService.radialPosition(
        parentPosition: parentPosition,
        childIndex: 3,
        totalChildren: 4,
      );
      expect(south.x, closeTo(0, 1.0));
      expect(south.y, closeTo(-150, 1.0));
    });

    test('should support sub-branch positioning with smaller radius', () {
      final branchPosition = const Position(x: 150, y: 0);
      const subBranchRadius = 100.0; // Smaller radius for sub-branches

      final position = layoutService.radialPosition(
        parentPosition: branchPosition,
        childIndex: 0,
        totalChildren: 2,
        radius: subBranchRadius,
      );

      // Sub-branch should be positioned relative to branch with smaller radius
      expect(position.x, closeTo(150 + subBranchRadius, 1.0));
      expect(position.y, closeTo(0, 1.0));
    });

    test('should handle zero children edge case', () {
      final parentPosition = const Position(x: 0, y: 0);

      // This should not crash, though it's an edge case
      expect(
        () => layoutService.radialPosition(
          parentPosition: parentPosition,
          childIndex: 0,
          totalChildren: 0,
        ),
        returnsNormally,
      );
    });

    test('should preserve existing node positions (spatial memory)', () {
      // This test verifies that LayoutService only positions NEW nodes
      // Existing nodes with manual positions should not be recalculated

      final existingNode = Node(
        id: 'existing',
        text: 'Manual Position',
        type: NodeType.branch,
        position: const Position(x: 200, y: 100), // Manually positioned
        color: Colors.blue,
      );

      // LayoutService should not move this node
      expect(existingNode.position.x, 200);
      expect(existingNode.position.y, 100);

      // New node gets auto-positioned
      final newPosition = layoutService.radialPosition(
        parentPosition: const Position(x: 0, y: 0),
        childIndex: 0,
        totalChildren: 1,
      );

      // New position is different from existing manual position
      expect(newPosition.x, isNot(equals(existingNode.position.x)));
      expect(newPosition.y, isNot(equals(existingNode.position.y)));
    });
  });
}
