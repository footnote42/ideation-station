import 'package:flutter/material.dart';
import 'package:ideation_station/models/node_symbol.dart';

/// Widget displaying a palette of symbols that can be attached to nodes.
///
/// Shows 8 symbol types (STAR, LIGHTBULB, QUESTION, CHECK, WARNING, HEART, ARROWS)
/// for visual meaning and emphasis on mind map nodes.
class SymbolPaletteWidget extends StatelessWidget {
  final Function(NodeSymbol) onSymbolSelected;
  final bool compact;
  final bool showLabels;

  const SymbolPaletteWidget({
    super.key,
    required this.onSymbolSelected,
    this.compact = false,
    this.showLabels = false,
  });

  // Available symbols with their icons and labels
  static const Map<SymbolType, IconData> _symbolIcons = {
    SymbolType.star: Icons.star,
    SymbolType.lightbulb: Icons.lightbulb,
    SymbolType.question: Icons.help,
    SymbolType.check: Icons.check_circle,
    SymbolType.warning: Icons.warning,
    SymbolType.heart: Icons.favorite,
    SymbolType.arrowUp: Icons.arrow_upward,
    SymbolType.arrowDown: Icons.arrow_downward,
  };

  static const Map<SymbolType, String> _symbolLabels = {
    SymbolType.star: 'Important',
    SymbolType.lightbulb: 'Idea',
    SymbolType.question: 'Question',
    SymbolType.check: 'Complete',
    SymbolType.warning: 'Warning',
    SymbolType.heart: 'Favorite',
    SymbolType.arrowUp: 'Growth',
    SymbolType.arrowDown: 'Decline',
  };

  @override
  Widget build(BuildContext context) {
    final itemSize = compact ? 40.0 : 56.0;
    final spacing = compact ? 8.0 : 12.0;
    final iconSize = compact ? 20.0 : 28.0;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: _symbolIcons.entries.map((entry) {
        final symbolType = entry.key;
        final icon = entry.value;
        final label = _symbolLabels[symbolType]!;

        return GestureDetector(
          onTap: () {
            // Create symbol with default position (TOP_RIGHT)
            final symbol = NodeSymbol(
              type: symbolType,
              position: SymbolPosition.topRight,
            );
            onSymbolSelected(symbol);
          },
          child: Tooltip(
            message: label,
            child: Container(
              width: itemSize,
              height: itemSize,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: iconSize,
                    color: _getSymbolColor(symbolType),
                  ),
                  if (showLabels && !compact)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        label,
                        style: const TextStyle(fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getSymbolColor(SymbolType type) {
    switch (type) {
      case SymbolType.star:
        return Colors.amber;
      case SymbolType.lightbulb:
        return Colors.orange;
      case SymbolType.question:
        return Colors.blue;
      case SymbolType.check:
        return Colors.green;
      case SymbolType.warning:
        return Colors.red;
      case SymbolType.heart:
        return Colors.pink;
      case SymbolType.arrowUp:
        return Colors.green;
      case SymbolType.arrowDown:
        return Colors.red.shade700;
    }
  }
}
