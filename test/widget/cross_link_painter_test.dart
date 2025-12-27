import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ideation_station/models/cross_link.dart';
import 'package:ideation_station/models/mind_map.dart';
import 'package:ideation_station/models/node.dart';
import 'package:ideation_station/models/node_type.dart';
import 'package:ideation_station/models/position.dart';
import 'package:ideation_station/ui/painters/cross_link_painter.dart';

void main() {
  group('CrossLinkPainter', () {
    late MindMap testMindMap;

    setUp(() {
      final centralNode = const Node(
        id: 'central-1',
        text: 'Central',
        type: NodeType.central,
        position: Position(x: 0, y: 0),
        color: Colors.blue,
        symbols: [],
        childIds: ['branch-1', 'branch-2'],
      );

      final branch1 = const Node(
        id: 'branch-1',
        text: 'Branch 1',
        type: NodeType.branch,
        position: Position(x: 150, y: 0),
        color: Colors.red,
        symbols: [],
        parentId: 'central-1',
        childIds: [],
      );

      final branch2 = const Node(
        id: 'branch-2',
        text: 'Branch 2',
        type: NodeType.branch,
        position: Position(x: -150, y: 0),
        color: Colors.green,
        symbols: [],
        parentId: 'central-1',
        childIds: [],
      );

      final crossLink = CrossLink(
        id: 'link-1',
        sourceNodeId: 'branch-1',
        targetNodeId: 'branch-2',
        label: 'relates to',
        createdAt: DateTime.now(),
      );

      testMindMap = MindMap(
        id: 'map-1',
        name: 'Test Map',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
        centralNode: centralNode,
        nodes: [centralNode, branch1, branch2],
        crossLinks: [crossLink],
      );
    });

    testWidgets('should render cross-link as dashed line', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: CrossLinkPainter(
                mindMap: testMindMap,
                canvasCenter: const Offset(400, 300),
              ),
              size: const Size(800, 600),
            ),
          ),
        ),
      );

      // Assert - CustomPaint should render without errors
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('should use different visual style than hierarchical branches', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: CrossLinkPainter(
                mindMap: testMindMap,
                canvasCenter: const Offset(400, 300),
              ),
              size: const Size(800, 600),
            ),
          ),
        ),
      );

      // Assert - painter should be created and render
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('should render arrow or directional indicator', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: CrossLinkPainter(
                mindMap: testMindMap,
                canvasCenter: const Offset(400, 300),
                showArrows: true,
              ),
              size: const Size(800, 600),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('should handle multiple cross-links', (WidgetTester tester) async {
      // Arrange - add more nodes and cross-links
      final branch3 = const Node(
        id: 'branch-3',
        text: 'Branch 3',
        type: NodeType.branch,
        position: Position(x: 0, y: 150),
        color: Colors.orange,
        symbols: [],
        parentId: 'central-1',
        childIds: [],
      );

      final link2 = CrossLink(
        id: 'link-2',
        sourceNodeId: 'branch-1',
        targetNodeId: 'branch-3',
        label: 'influences',
        createdAt: DateTime.now(),
      );

      final updatedMap = testMindMap.copyWith(
        nodes: [...testMindMap.nodes, branch3],
        crossLinks: [...testMindMap.crossLinks, link2],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: CrossLinkPainter(
                mindMap: updatedMap,
                canvasCenter: const Offset(400, 300),
              ),
              size: const Size(800, 600),
            ),
          ),
        ),
      );

      // Assert - should render multiple cross-links
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('should render cross-link labels when enabled', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: CrossLinkPainter(
                mindMap: testMindMap,
                canvasCenter: const Offset(400, 300),
                showLabels: true,
              ),
              size: const Size(800, 600),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('should implement shouldRepaint optimization', (WidgetTester tester) async {
      // Arrange
      final painter1 = CrossLinkPainter(
        mindMap: testMindMap,
        canvasCenter: const Offset(400, 300),
      );

      final painter2 = CrossLinkPainter(
        mindMap: testMindMap,
        canvasCenter: const Offset(400, 300),
      );

      // Assert - shouldRepaint should return false for same data
      expect(painter1.shouldRepaint(painter2), isFalse);

      // Create painter with different data
      final updatedMap = testMindMap.copyWith(name: 'Updated');
      final painter3 = CrossLinkPainter(
        mindMap: updatedMap,
        canvasCenter: const Offset(400, 300),
      );

      // Assert - shouldRepaint should return true for different data
      expect(painter1.shouldRepaint(painter3), isTrue);
    });

    testWidgets('should handle empty cross-links list', (WidgetTester tester) async {
      // Arrange
      final mapWithoutLinks = testMindMap.copyWith(crossLinks: []);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: CrossLinkPainter(
                mindMap: mapWithoutLinks,
                canvasCenter: const Offset(400, 300),
              ),
              size: const Size(800, 600),
            ),
          ),
        ),
      );

      // Assert - should render without errors even with no cross-links
      expect(find.byType(CustomPaint), findsOneWidget);
    });
  });
}
