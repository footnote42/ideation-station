import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideation_station/models/mind_map.dart';
import 'package:ideation_station/ui/painters/connection_painter.dart';
import 'package:ideation_station/ui/widgets/node_widget.dart';
import 'package:ideation_station/utils/constants.dart';

/// Main canvas widget for displaying and interacting with mind maps.
///
/// Features:
/// - InteractiveViewer for pan and zoom (FR-012, FR-013)
/// - CustomPaint for curved branch connections (FR-007)
/// - Stack-based absolute positioning for nodes
/// - Performance optimizations (RepaintBoundary, shouldRepaint)
class CanvasWidget extends ConsumerStatefulWidget {
  final MindMap mindMap;
  final Function(String nodeId)? onNodeTap;

  const CanvasWidget({
    super.key,
    required this.mindMap,
    this.onNodeTap,
  });

  @override
  ConsumerState<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends ConsumerState<CanvasWidget> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstants.canvasBackground,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: AppConstants.minZoomScale, // 0.5x
        maxScale: AppConstants.maxZoomScale, // 2.0x
        boundaryMargin: const EdgeInsets.all(AppConstants.canvasBoundaryMargin),
        constrained: false,
        child: SizedBox(
          width: AppConstants.canvasBoundaryMargin * 2,
          height: AppConstants.canvasBoundaryMargin * 2,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Layer 1: Connection lines (background)
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: ConnectionPainter(
                      mindMap: widget.mindMap,
                      canvasCenter: Offset(
                        AppConstants.canvasBoundaryMargin,
                        AppConstants.canvasBoundaryMargin,
                      ),
                    ),
                  ),
                ),
              ),

              // Layer 2: Nodes (foreground)
              ...widget.mindMap.nodes.map((node) {
                // Convert normalized position to canvas position
                final canvasX = AppConstants.canvasBoundaryMargin + node.position.x;
                final canvasY = AppConstants.canvasBoundaryMargin + node.position.y;

                return Positioned(
                  left: canvasX - 60, // Center the node widget
                  top: canvasY - 30,
                  child: RepaintBoundary(
                    child: NodeWidget(
                      node: node,
                      onTap: widget.onNodeTap != null
                          ? () => widget.onNodeTap!(node.id)
                          : null,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
