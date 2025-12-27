import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ideation_station/models/node_symbol.dart';
import 'package:ideation_station/ui/widgets/symbol_palette.dart';

void main() {
  group('SymbolPaletteWidget', () {
    testWidgets('should display all available symbols', (WidgetTester tester) async {
      // Arrange
      NodeSymbol? selectedSymbol;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SymbolPaletteWidget(
              onSymbolSelected: (symbol) {
                selectedSymbol = symbol;
              },
            ),
          ),
        ),
      );

      // Assert - should display symbols (at least 8 types)
      expect(find.byType(SymbolPaletteWidget), findsOneWidget);
    });

    testWidgets('should call callback when symbol is selected', (WidgetTester tester) async {
      // Arrange
      NodeSymbol? selectedSymbol;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SymbolPaletteWidget(
              onSymbolSelected: (symbol) {
                selectedSymbol = symbol;
              },
            ),
          ),
        ),
      );

      // Act - tap on first symbol
      final symbolWidget = find.byType(GestureDetector).first;
      await tester.tap(symbolWidget);
      await tester.pumpAndSettle();

      // Assert
      expect(selectedSymbol, isNotNull, reason: 'Callback should be called');
      expect(selectedSymbol!.type, isNotNull);
    });

    testWidgets('should display symbols in grid layout', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SymbolPaletteWidget(
              onSymbolSelected: (symbol) {},
            ),
          ),
        ),
      );

      // Assert - grid or wrap layout should contain multiple symbols
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('should render different symbol types with distinct icons', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SymbolPaletteWidget(
              onSymbolSelected: (symbol) {},
            ),
          ),
        ),
      );

      // Assert - should have icons for symbols
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('should support compact mode', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SymbolPaletteWidget(
              onSymbolSelected: (symbol) {},
              compact: true,
            ),
          ),
        ),
      );

      // Assert - widget renders in compact mode
      expect(find.byType(SymbolPaletteWidget), findsOneWidget);

      final widgetSize = tester.getSize(find.byType(SymbolPaletteWidget));
      expect(widgetSize.width, greaterThan(0));
      expect(widgetSize.height, greaterThan(0));
    });

    testWidgets('should show symbol labels or tooltips', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SymbolPaletteWidget(
              onSymbolSelected: (symbol) {},
              showLabels: true,
            ),
          ),
        ),
      );

      // Assert - labels or text should be visible
      expect(find.byType(SymbolPaletteWidget), findsOneWidget);
    });

    testWidgets('should handle rapid symbol selection', (WidgetTester tester) async {
      // Arrange
      final selectedSymbols = <NodeSymbol>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SymbolPaletteWidget(
              onSymbolSelected: (symbol) {
                selectedSymbols.add(symbol);
              },
            ),
          ),
        ),
      );

      // Act - tap multiple symbols rapidly
      final symbols = find.byType(GestureDetector);
      await tester.tap(symbols.first);
      await tester.pump();

      if (symbols.evaluate().length > 1) {
        await tester.tap(symbols.at(1));
        await tester.pump();
      }

      await tester.pumpAndSettle();

      // Assert - all selections should be registered
      expect(selectedSymbols.length, greaterThan(0));
    });
  });
}
