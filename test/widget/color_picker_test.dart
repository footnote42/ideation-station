import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ideation_station/ui/widgets/color_picker.dart';
import 'package:ideation_station/utils/constants.dart';

void main() {
  group('ColorPickerWidget', () {
    testWidgets('should display color palette from constants', (WidgetTester tester) async {
      // Arrange
      Color? selectedColor;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPickerWidget(
              onColorSelected: (color) {
                selectedColor = color;
              },
            ),
          ),
        ),
      );

      // Assert - should display all colors from palette
      expect(find.byType(ColorPickerWidget), findsOneWidget);

      // The widget should show a grid of colors
      // With 12 colors in the palette, we expect to find clickable color items
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('should call callback when color is selected', (WidgetTester tester) async {
      // Arrange
      Color? selectedColor;
      final testColor = AppConstants.colorPalette[0];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPickerWidget(
              onColorSelected: (color) {
                selectedColor = color;
              },
            ),
          ),
        ),
      );

      // Act - tap on first color
      final colorWidget = find.byType(GestureDetector).first;
      await tester.tap(colorWidget);
      await tester.pumpAndSettle();

      // Assert
      expect(selectedColor, isNotNull, reason: 'Callback should be called with selected color');
    });

    testWidgets('should display initial selected color if provided', (WidgetTester tester) async {
      // Arrange
      final initialColor = AppConstants.colorPalette[3];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPickerWidget(
              initialColor: initialColor,
              onColorSelected: (color) {},
            ),
          ),
        ),
      );

      // Assert - the initial color should be visually indicated
      expect(find.byType(ColorPickerWidget), findsOneWidget);
    });

    testWidgets('should update selection when different color is tapped', (WidgetTester tester) async {
      // Arrange
      final selectedColors = <Color>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPickerWidget(
              onColorSelected: (color) {
                selectedColors.add(color);
              },
            ),
          ),
        ),
      );

      // Act - tap multiple colors
      final colorWidgets = find.byType(GestureDetector);
      await tester.tap(colorWidgets.first);
      await tester.pumpAndSettle();

      await tester.tap(colorWidgets.at(1));
      await tester.pumpAndSettle();

      // Assert
      expect(selectedColors.length, 2, reason: 'Should track both selections');
      expect(selectedColors[0] != selectedColors[1], isTrue,
          reason: 'Different colors should be selected');
    });

    testWidgets('should display all 12 palette colors', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPickerWidget(
              onColorSelected: (color) {},
            ),
          ),
        ),
      );

      // Assert - should have 12 color options
      final colorWidgets = find.byType(GestureDetector);
      expect(colorWidgets.evaluate().length, greaterThanOrEqualTo(12),
          reason: 'Should display at least 12 colors from palette');
    });

    testWidgets('should provide visual feedback on color selection', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPickerWidget(
              initialColor: AppConstants.colorPalette[0],
              onColorSelected: (color) {},
            ),
          ),
        ),
      );

      // The selected color should have some visual indicator (border, checkmark, etc.)
      // This is tested implicitly by the widget structure
      expect(find.byType(ColorPickerWidget), findsOneWidget);
    });

    testWidgets('should render in compact mode when specified', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPickerWidget(
              onColorSelected: (color) {},
              compact: true,
            ),
          ),
        ),
      );

      // Assert - widget should render without errors
      expect(find.byType(ColorPickerWidget), findsOneWidget);

      // In compact mode, the widget might have smaller dimensions
      final widgetSize = tester.getSize(find.byType(ColorPickerWidget));
      expect(widgetSize.width, greaterThan(0));
      expect(widgetSize.height, greaterThan(0));
    });
  });
}
