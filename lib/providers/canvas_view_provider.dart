import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for canvas view interactions.
///
/// Tracks:
/// - Selected node ID
/// - Current interaction mode (view, edit, create link)
/// - Canvas viewport state
class CanvasViewState {
  final String? selectedNodeId;
  final CanvasMode mode;
  final double zoomLevel;

  const CanvasViewState({
    this.selectedNodeId,
    this.mode = CanvasMode.view,
    this.zoomLevel = 1.0,
  });

  CanvasViewState copyWith({
    String? selectedNodeId,
    CanvasMode? mode,
    double? zoomLevel,
  }) {
    return CanvasViewState(
      selectedNodeId: selectedNodeId ?? this.selectedNodeId,
      mode: mode ?? this.mode,
      zoomLevel: zoomLevel ?? this.zoomLevel,
    );
  }
}

/// Canvas interaction modes.
enum CanvasMode {
  view, // Default viewing/navigating mode
  editNode, // Editing node text
  createLink, // Creating cross-link between nodes
}

/// State notifier for canvas view management.
class CanvasViewNotifier extends StateNotifier<CanvasViewState> {
  CanvasViewNotifier() : super(const CanvasViewState());

  /// Selects a node for operations.
  void selectNode(String nodeId) {
    state = state.copyWith(selectedNodeId: nodeId);
  }

  /// Clears node selection.
  void clearSelection() {
    state = state.copyWith(selectedNodeId: null);
  }

  /// Sets the canvas interaction mode.
  void setMode(CanvasMode mode) {
    state = state.copyWith(mode: mode);
  }

  /// Updates zoom level.
  void setZoomLevel(double zoom) {
    state = state.copyWith(zoomLevel: zoom);
  }

  /// Toggles node selection (select if not selected, clear if already selected).
  void toggleNodeSelection(String nodeId) {
    if (state.selectedNodeId == nodeId) {
      clearSelection();
    } else {
      selectNode(nodeId);
    }
  }
}

/// Provider for canvas view state.
final canvasViewProvider =
    StateNotifierProvider<CanvasViewNotifier, CanvasViewState>((ref) {
  return CanvasViewNotifier();
});
