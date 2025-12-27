import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideation_station/models/mind_map.dart';
import 'package:ideation_station/ui/painters/connection_painter.dart';
import 'package:ideation_station/ui/painters/cross_link_painter.dart';
import 'package:ideation_station/ui/widgets/node_widget.dart';
import 'package:ideation_station/utils/constants.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

/// Main canvas widget for displaying and interacting with mind maps.
///
/// Features:
/// - InteractiveViewer for pan and zoom (FR-012, FR-013)
/// - CustomPaint for curved branch connections (FR-007)
/// - Stack-based absolute positioning for nodes
/// - Performance optimizations (RepaintBoundary, shouldRepaint)
/// - Symbol attachment via long-press
class CanvasWidget extends ConsumerStatefulWidget {
  final MindMap mindMap;
  final Function(String nodeId)? onNodeTap;
  final Function(String nodeId)? onNodeLongPress;

  const CanvasWidget({
    super.key,
    required this.mindMap,
    this.onNodeTap,
    this.onNodeLongPress,
  });

  @override
  ConsumerState<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends ConsumerState<CanvasWidget> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    // Center the viewport on the canvas center (where nodes are positioned)
    // The canvas is 20000x20000, centered at (10000, 10000)
    // We need to translate the view to show this center point
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      final dx = screenSize.width / 2 - AppConstants.canvasBoundaryMargin;
      final dy = screenSize.height / 2 - AppConstants.canvasBoundaryMargin;
      _transformationController.value = Matrix4.identity()
        ..translateByVector3(Vector3(dx, dy, 0.0));
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  /// Calculate visible viewport bounds for culling (T099).
  ///
  /// Returns the visible rectangle in canvas coordinates, with padding for smooth scrolling.
  Rect _getVisibleViewport() {
    final screenSize = MediaQuery.of(context).size;
    final transform = _transformationController.value;

    // Get scale and translation from transformation matrix
    final scale = transform.getMaxScaleOnAxis();
    final translation = transform.getTranslation();

    // Calculate visible area in canvas coordinates
    // Add padding (50% extra) to avoid pop-in during scrolling/zooming
    const paddingFactor = 1.5;
    final viewportWidth = (screenSize.width / scale) * paddingFactor;
    final viewportHeight = (screenSize.height / scale) * paddingFactor;

    final visibleLeft = (-translation.x / scale) - (viewportWidth * 0.25);
    final visibleTop = (-translation.y / scale) - (viewportHeight * 0.25);

    return Rect.fromLTWH(visibleLeft, visibleTop, viewportWidth, viewportHeight);
  }

  /// Check if a node is within the visible viewport (T099).
  bool _isNodeVisible(Offset nodePosition, Rect viewport) {
    // Node rendering bounds (approximate)
    const nodeWidth = 150.0;
    const nodeHeight = 80.0;

    final nodeRect = Rect.fromLTWH(
      nodePosition.dx - nodeWidth / 2,
      nodePosition.dy - nodeHeight / 2,
      nodeWidth,
      nodeHeight,
    );

    return viewport.overlaps(nodeRect);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate visible viewport for culling optimization (T099)
    final viewport = _getVisibleViewport();

    // Filter visible nodes for large mind map optimization
    // Only render nodes within viewport (with padding) to maintain 60fps
    final visibleNodes = widget.mindMap.nodes.where((node) {
      final canvasPos = Offset(
        AppConstants.canvasBoundaryMargin + node.position.x,
        AppConstants.canvasBoundaryMargin + node.position.y,
      );
      return _isNodeVisible(canvasPos, viewport);
    }).toList();

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

              // Layer 2: Nodes (foreground) - viewport culled for performance (T099)
              ...visibleNodes.map((node) {
                // Convert normalized position to canvas position
                final canvasX = AppConstants.canvasBoundaryMargin + node.position.x;
                final canvasY = AppConstants.canvasBoundaryMargin + node.position.y;

                return Positioned(
                  left: canvasX - 75, // Center the node widget
                  top: canvasY - 40,
                  child: RepaintBoundary(
                    child: SizedBox(
                      width: 150,
                      height: 80,
                      child: NodeWidget(
                        node: node,
                        onTap: widget.onNodeTap != null
                            ? () => widget.onNodeTap!(node.id)
                            : null,
                        onLongPress: widget.onNodeLongPress != null
                            ? () => widget.onNodeLongPress!(node.id)
                            : null,
                      ),
                    ),
                  ),
                );
              }),

              // Layer 3: Cross-links (overlay on nodes)
              if (widget.mindMap.crossLinks.isNotEmpty)
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: CrossLinkPainter(
                        mindMap: widget.mindMap,
                        canvasCenter: Offset(
                          AppConstants.canvasBoundaryMargin,
                          AppConstants.canvasBoundaryMargin,
                        ),
                        showArrows: true,
                        showLabels: false,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
