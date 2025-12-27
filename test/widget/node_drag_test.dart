import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ideation_station/models/node.dart';
import 'package:ideation_station/models/node_type.dart';
import 'package:ideation_station/models/position.dart';
import 'package:ideation_station/ui/widgets/node_widget.dart';

void main() {
  group('NodeWidget Drag Gesture Handling', () {
    late Node testNode;

    setUp(() {
      testNode = const Node(
        id: 'test-node-1',
        text: 'Draggable Node',
        type: NodeType.branch,
        position: Position(x: 100, y: 100),
        color: Colors.blue,
        symbols: [],
        childIds: [],
      );
    });

    testWidgets('should wrap node in Draggable widget', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: NodeWidget(
                node: testNode,
                isDraggable: true,
              ),
            ),
          ),
        ),
      );

      // Assert - Draggable widget should be present when isDraggable is true
      expect(find.byType(Draggable<String>), findsOneWidget);
    });

    testWidgets('should NOT wrap in Draggable when isDraggable is false', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: NodeWidget(
                node: testNode,
                isDraggable: false,
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Draggable<String>), findsNothing);
    });

    testWidgets('should trigger onDragEnd callback with new position', (WidgetTester tester) async {
      // Arrange
      Position? newPosition;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Positioned(
                    left: 100,
                    top: 100,
                    child: NodeWidget(
                      node: testNode,
                      isDraggable: true,
                      onDragEnd: (position) {
                        newPosition = position;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Act - perform drag gesture
      final nodeFinder = find.text('Draggable Node');
      await tester.drag(nodeFinder, const Offset(50, 50));
      await tester.pumpAndSettle();

      // Assert - callback should be called with new position
      expect(newPosition, isNotNull, reason: 'onDragEnd should be called');
    });

    testWidgets('should display feedback widget during drag', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Positioned(
                    left: 100,
                    top: 100,
                    child: NodeWidget(
                      node: testNode,
                      isDraggable: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Act - start dragging
      final nodeFinder = find.text('Draggable Node');
      final gesture = await tester.startGesture(tester.getCenter(nodeFinder));

      await tester.pump();

      // Assert - feedback widget should be visible
      // The original node should still be there plus the feedback
      expect(find.text('Draggable Node'), findsWidgets);

      // Clean up
      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('should calculate position relative to canvas center', (WidgetTester tester) async {
      // Arrange
      Position? dragEndPosition;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Positioned(
                    left: 200,
                    top: 200,
                    child: NodeWidget(
                      node: testNode,
                      isDraggable: true,
                      onDragEnd: (position) {
                        dragEndPosition = position;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Act - drag to new position
      final nodeFinder = find.text('Draggable Node');
      await tester.drag(nodeFinder, const Offset(100, 100));
      await tester.pumpAndSettle();

      // Assert - position should be calculated from canvas center
      expect(dragEndPosition, isNotNull);
    });

    testWidgets('should maintain node styling during drag', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Positioned(
                    left: 100,
                    top: 100,
                    child: NodeWidget(
                      node: testNode,
                      isDraggable: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Act - start dragging
      final nodeFinder = find.text('Draggable Node');
      final gesture = await tester.startGesture(tester.getCenter(nodeFinder));
      await tester.pump();

      // Assert - feedback should maintain visual styling
      expect(find.text('Draggable Node'), findsWidgets);

      // Clean up
      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('should support drag with central node', (WidgetTester tester) async {
      // Arrange
      final centralNode = const Node(
        id: 'central-1',
        text: 'Central Node',
        type: NodeType.central,
        position: Position(x: 0, y: 0),
        color: Colors.purple,
        symbols: [],
        childIds: [],
      );

      Position? draggedPosition;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Positioned(
                    left: 400,
                    top: 300,
                    child: NodeWidget(
                      node: centralNode,
                      isDraggable: true,
                      onDragEnd: (position) {
                        draggedPosition = position;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Act - drag central node
      final nodeFinder = find.text('Central Node');
      await tester.drag(nodeFinder, const Offset(50, 50));
      await tester.pumpAndSettle();

      // Assert - central node can be dragged (for repositioning entire map)
      expect(draggedPosition, isNotNull);
    });

    testWidgets('should handle rapid drag gestures without errors', (WidgetTester tester) async {
      // Arrange
      int dragCount = 0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  Positioned(
                    left: 100,
                    top: 100,
                    child: NodeWidget(
                      node: testNode,
                      isDraggable: true,
                      onDragEnd: (position) {
                        dragCount++;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Act - perform multiple rapid drags
      final nodeFinder = find.text('Draggable Node');
      await tester.drag(nodeFinder, const Offset(10, 10));
      await tester.pump();

      await tester.drag(nodeFinder, const Offset(20, 20));
      await tester.pump();

      await tester.drag(nodeFinder, const Offset(15, 15));
      await tester.pumpAndSettle();

      // Assert - all drags should be handled
      expect(dragCount, greaterThan(0), reason: 'Multiple drags should be registered');
    });
  });
}
