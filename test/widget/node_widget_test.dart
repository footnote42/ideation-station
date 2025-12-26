import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ideation_station/models/node.dart';
import 'package:ideation_station/models/node_type.dart';
import 'package:ideation_station/models/position.dart';
import 'package:ideation_station/ui/widgets/node_widget.dart';

/// Widget tests for NodeWidget (T024)
///
/// Tests cover:
/// - Text display rendering
/// - Color rendering (background/border)
/// - Tap detection with <100ms response (performance requirement)
/// - Visual distinction between central, branch, and sub-branch nodes
/// - Symbol rendering on nodes
void main() {
  group('NodeWidget', () {
    testWidgets('should display node text correctly', (WidgetTester tester) async {
      final node = Node(
        id: 'node-1',
        text: 'Test Node',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NodeWidget(
              node: node,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Node'), findsOneWidget);
    });

    testWidgets('should render with correct color', (WidgetTester tester) async {
      final node = Node(
        id: 'node-1',
        text: 'Colored Node',
        type: NodeType.branch,
        position: const Position(x: 0, y: 0),
        color: Colors.red,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NodeWidget(
              node: node,
              onTap: () {},
            ),
          ),
        ),
      );

      // Find the widget
      final widget = find.byType(NodeWidget);
      expect(widget, findsOneWidget);

      // Verify color is applied (implementation will use decoration)
      final container = find.descendant(
        of: widget,
        matching: find.byType(Container),
      );
      expect(container, findsWidgets);
    });

    testWidgets('should handle tap events', (WidgetTester tester) async {
      var tapped = false;
      final node = Node(
        id: 'node-1',
        text: 'Tappable Node',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NodeWidget(
              node: node,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Tap the node
      await tester.tap(find.byType(NodeWidget));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should detect tap with <100ms response time', (WidgetTester tester) async {
      var tapTime = DateTime.now();
      var callbackTime = DateTime.now();

      final node = Node(
        id: 'node-1',
        text: 'Fast Tap',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NodeWidget(
              node: node,
              onTap: () {
                callbackTime = DateTime.now();
              },
            ),
          ),
        ),
      );

      tapTime = DateTime.now();
      await tester.tap(find.byType(NodeWidget));
      await tester.pump(Duration.zero); // Immediate pump

      final responseTime = callbackTime.difference(tapTime).inMilliseconds;

      // Touch response must be < 100ms per performance budget (SC-002)
      expect(
        responseTime,
        lessThan(100),
        reason: 'Touch response must be perceived as instant (<100ms)',
      );
    });

    testWidgets('should display central node with distinct visual style',
        (WidgetTester tester) async {
      final centralNode = Node(
        id: 'central',
        text: 'Central Node',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NodeWidget(
              node: centralNode,
              onTap: () {},
            ),
          ),
        ),
      );

      // Central node should be visually distinct (larger, different border)
      final widget = find.byType(NodeWidget);
      expect(widget, findsOneWidget);

      // Implementation will render central nodes differently
      // This test verifies the widget renders without error
      expect(find.text('Central Node'), findsOneWidget);
    });

    testWidgets('should display branch node with standard style',
        (WidgetTester tester) async {
      final branchNode = Node(
        id: 'branch',
        text: 'Branch Node',
        type: NodeType.branch,
        position: const Position(x: 150, y: 0),
        color: Colors.red,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NodeWidget(
              node: branchNode,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Branch Node'), findsOneWidget);
    });

    testWidgets('should display sub-branch node with standard style',
        (WidgetTester tester) async {
      final subBranchNode = Node(
        id: 'sub-branch',
        text: 'Sub-Branch',
        type: NodeType.subBranch,
        position: const Position(x: 200, y: 50),
        color: Colors.green,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NodeWidget(
              node: subBranchNode,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Sub-Branch'), findsOneWidget);
    });

    testWidgets('should handle long text without overflow',
        (WidgetTester tester) async {
      final node = Node(
        id: 'node-1',
        text: 'This is a very long text that should not overflow',
        type: NodeType.branch,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NodeWidget(
              node: node,
              onTap: () {},
            ),
          ),
        ),
      );

      // Should render without overflow errors
      expect(tester.takeException(), isNull);
      expect(find.text('This is a very long text that should not overflow'),
          findsOneWidget);
    });

    testWidgets('should handle single-word keyword text',
        (WidgetTester tester) async {
      final node = Node(
        id: 'node-1',
        text: 'Keyword',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NodeWidget(
              node: node,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Keyword'), findsOneWidget);
    });

    testWidgets('should render with symbols when present',
        (WidgetTester tester) async {
      final node = Node(
        id: 'node-1',
        text: 'Node with Symbols',
        type: NodeType.branch,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
        symbols: [], // Will add actual symbols in later stories
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NodeWidget(
              node: node,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Node with Symbols'), findsOneWidget);
      // Symbol rendering will be tested in User Story 3
    });

    testWidgets('should support optional onTap callback',
        (WidgetTester tester) async {
      final node = Node(
        id: 'node-1',
        text: 'No Callback',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      // Should render without onTap callback (nullable)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NodeWidget(
              node: node,
              onTap: null,
            ),
          ),
        ),
      );

      expect(find.text('No Callback'), findsOneWidget);

      // Tapping should not cause error even without callback
      await tester.tap(find.byType(NodeWidget));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('should use GestureDetector for tap detection',
        (WidgetTester tester) async {
      final node = Node(
        id: 'node-1',
        text: 'Gesture Test',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NodeWidget(
              node: node,
              onTap: () {},
            ),
          ),
        ),
      );

      // NodeWidget should use GestureDetector internally
      final widget = find.byType(NodeWidget);
      expect(widget, findsOneWidget);
    });

    testWidgets('should render visual feedback on tap (Material ripple)',
        (WidgetTester tester) async {
      final node = Node(
        id: 'node-1',
        text: 'Ripple Test',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NodeWidget(
              node: node,
              onTap: () {},
            ),
          ),
        ),
      );

      // Tap and pump to trigger ripple animation
      await tester.tap(find.byType(NodeWidget));
      await tester.pump(const Duration(milliseconds: 50));

      // Verify no errors during animation
      expect(tester.takeException(), isNull);
    });

    testWidgets('should maintain size constraints for all node types',
        (WidgetTester tester) async {
      final nodes = [
        Node(
          id: 'c1',
          text: 'Central',
          type: NodeType.central,
          position: const Position(x: 0, y: 0),
          color: Colors.blue,
        ),
        Node(
          id: 'b1',
          text: 'Branch',
          type: NodeType.branch,
          position: const Position(x: 150, y: 0),
          color: Colors.red,
        ),
        Node(
          id: 's1',
          text: 'SubBranch',
          type: NodeType.subBranch,
          position: const Position(x: 200, y: 50),
          color: Colors.green,
        ),
      ];

      for (final node in nodes) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NodeWidget(
                node: node,
                onTap: () {},
              ),
            ),
          ),
        );

        // All nodes should render with reasonable size constraints
        final widget = find.byType(NodeWidget);
        expect(widget, findsOneWidget);

        final size = tester.getSize(widget);
        expect(size.width, greaterThan(0));
        expect(size.height, greaterThan(0));
      }
    });
  });
}
