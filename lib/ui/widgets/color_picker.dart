import 'package:flutter/material.dart';
import 'package:ideation_station/utils/constants.dart';

/// Color picker widget displaying the app's color palette.
///
/// Shows a grid of colors from AppConstants.colorPalette for node customization.
/// Supports both normal and compact display modes.
class ColorPickerWidget extends StatefulWidget {
  final Color? initialColor;
  final Function(Color) onColorSelected;
  final bool compact;

  const ColorPickerWidget({
    super.key,
    this.initialColor,
    required this.onColorSelected,
    this.compact = false,
  });

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final itemSize = widget.compact ? 36.0 : 48.0;
    final spacing = widget.compact ? 8.0 : 12.0;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: AppConstants.colorPalette.map((color) {
        final isSelected = _selectedColor?.value == color.value;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = color;
            });
            widget.onColorSelected(color);
          },
          child: Container(
            width: itemSize,
            height: itemSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.black26,
                width: isSelected ? 3.0 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}
