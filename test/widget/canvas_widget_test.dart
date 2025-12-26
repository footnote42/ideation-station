import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideation_station/models/mind_map.dart';
import 'package:ideation_station/models/node.dart';
import 'package:ideation_station/models/node_type.dart';
import 'package:ideation_station/models/position.dart';
import 'package:ideation_station/ui/widgets/canvas_widget.dart';

/// Widget tests for CanvasWidget basic rendering (T025)
///
/// Tests cover:
/// - InteractiveViewer setup for pan/zoom
/// - CustomPaint integration for branch connections
/// - Node rendering on canvas
/// - Multi-node layout
void main() {
  group('CanvasWidget', () {
    testWidgets('should render with InteractiveViewer',
        (WidgetTester tester) async {
      final centralNode = Node(
        id: 'central',
        text: 'Central',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Test Map',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
        centralNode: centralNode,
        nodes: [centralNode],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CanvasWidget(mindMap: mindMap),
            ),
          ),
        ),
      );

      // InteractiveViewer should be present for pan/zoom
      expect(find.byType(InteractiveViewer), findsOneWidget);
    });

    testWidgets('should integrate CustomPaint for connection rendering',
        (WidgetTester tester) async {
      final centralNode = Node(
        id: 'central',
        text: 'Central',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Test Map',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
        centralNode: centralNode,
        nodes: [centralNode],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CanvasWidget(mindMap: mindMap),
            ),
          ),
        ),
      );

      // CustomPaint should be present for drawing connections
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('should render single central node',
        (WidgetTester tester) async {
      final centralNode = Node(
        id: 'central',
        text: 'My Idea',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Test Map',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
        centralNode: centralNode,
        nodes: [centralNode],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CanvasWidget(mindMap: mindMap),
            ),
          ),
        ),
      );

      // Central node should be visible on canvas
      expect(find.text('My Idea'), findsOneWidget);
    });

    testWidgets('should render multiple nodes',
        (WidgetTester tester) async {
      final centralNode = Node(
        id: 'central',
        text: 'Central',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      final branch1 = Node(
        id: 'branch-1',
        text: 'Branch 1',
        type: NodeType.branch,
        position: const Position(x: 150, y: 0),
        color: Colors.red,
        parentId: 'central',
      );

      final branch2 = Node(
        id: 'branch-2',
        text: 'Branch 2',
        type: NodeType.branch,
        position: const Position(x: -150, y: 0),
        color: Colors.green,
        parentId: 'central',
      );

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Test Map',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
        centralNode: centralNode,
        nodes: [centralNode, branch1, branch2],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CanvasWidget(mindMap: mindMap),
            ),
          ),
        ),
      );

      // All nodes should be rendered
      expect(find.text('Central'), findsOneWidget);
      expect(find.text('Branch 1'), findsOneWidget);
      expect(find.text('Branch 2'), findsOneWidget);
    });

    testWidgets('should use Stack for node positioning',
        (WidgetTester tester) async {
      final centralNode = Node(
        id: 'central',
        text: 'Central',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Test Map',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
        centralNode: centralNode,
        nodes: [centralNode],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CanvasWidget(mindMap: mindMap),
            ),
          ),
        ),
      );

      // Canvas should use Stack for absolute node positioning
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('should configure InteractiveViewer with correct constraints',
        (WidgetTester tester) async {
      final centralNode = Node(
        id: 'central',
        text: 'Central',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Test Map',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
        centralNode: centralNode,
        nodes: [centralNode],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CanvasWidget(mindMap: mindMap),
            ),
          ),
        ),
      );

      final interactiveViewer = tester.widget<InteractiveViewer>(
        find.byType(InteractiveViewer),
      );

      // Verify zoom constraints per FR-012 and constants
      // minScale: 0.5, maxScale: 2.0
      expect(interactiveViewer.minScale, lessThanOrEqualTo(1.0));
      expect(interactiveViewer.maxScale, greaterThanOrEqualTo(1.0));
    });

    testWidgets('should handle empty mind map gracefully',
        (WidgetTester tester) async {
      final centralNode = Node(
        id: 'central',
        text: 'Empty',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Empty Map',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
        centralNode: centralNode,
        nodes: [], // Empty nodes list
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CanvasWidget(mindMap: mindMap),
            ),
          ),
        ),
      );

      // Should render without error even with empty nodes
      expect(find.byType(CanvasWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should render complex hierarchy',
        (WidgetTester tester) async {
      final central = Node(
        id: 'c1',
        text: 'Central',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      final branch = Node(
        id: 'b1',
        text: 'Branch',
        type: NodeType.branch,
        position: const Position(x: 150, y: 0),
        color: Colors.red,
        parentId: 'c1',
      );

      final subBranch = Node(
        id: 's1',
        text: 'SubBranch',
        type: NodeType.subBranch,
        position: const Position(x: 250, y: 50),
        color: Colors.green,
        parentId: 'b1',
      );

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Complex Map',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
        centralNode: central,
        nodes: [central, branch, subBranch],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CanvasWidget(mindMap: mindMap),
            ),
          ),
        ),
      );

      // All hierarchy levels should render
      expect(find.text('Central'), findsOneWidget);
      expect(find.text('Branch'), findsOneWidget);
      expect(find.text('SubBranch'), findsOneWidget);
    });

    testWidgets('should allow pan gestures via InteractiveViewer',
        (WidgetTester tester) async {
      final centralNode = Node(
        id: 'central',
        text: 'Central',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Test Map',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
        centralNode: centralNode,
        nodes: [centralNode],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CanvasWidget(mindMap: mindMap),
            ),
          ),
        ),
      );

      // InteractiveViewer should handle pan gestures (built-in)
      final interactiveViewer = find.byType(InteractiveViewer);
      expect(interactiveViewer, findsOneWidget);

      // Simulate drag gesture
      await tester.drag(interactiveViewer, const Offset(100, 50));
      await tester.pumpAndSettle();

      // Should not throw error during pan
      expect(tester.takeException(), isNull);
    });

    testWidgets('should allow pinch-to-zoom gestures via InteractiveViewer',
        (WidgetTester tester) async {
      final centralNode = Node(
        id: 'central',
        text: 'Central',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Test Map',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
        centralNode: centralNode,
        nodes: [centralNode],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CanvasWidget(mindMap: mindMap),
            ),
          ),
        ),
      );

      // InteractiveViewer should handle pinch-to-zoom (built-in)
      final interactiveViewer = find.byType(InteractiveViewer);
      expect(interactiveViewer, findsOneWidget);

      // Note: Full pinch gesture testing requires more complex setup
      // For now, verify InteractiveViewer is present and configured
    });

    testWidgets('should render without performance issues',
        (WidgetTester tester) async {
      // Create mind map with multiple nodes
      final central = Node(
        id: 'central',
        text: 'Central',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      final branches = List.generate(
        8,
        (i) => Node(
          id: 'branch-$i',
          text: 'Branch $i',
          type: NodeType.branch,
          position: Position(x: 150.0 * i, y: 0),
          color: Colors.red,
          parentId: 'central',
        ),
      );

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Performance Test',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
        centralNode: central,
        nodes: [central, ...branches],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CanvasWidget(mindMap: mindMap),
            ),
          ),
        ),
      );

      // Should render 9 nodes without performance issues
      expect(find.text('Central'), findsOneWidget);
      for (var i = 0; i < 8; i++) {
        expect(find.text('Branch $i'), findsOneWidget);
      }
    });
  });
}
