import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for canvas view interactions.
///
/// Tracks:
/// - Selected node ID
/// - Current interaction mode (view, edit, create link)
/// - Canvas viewport state
/// - Link creation workflow state
class CanvasViewState {
  final String? selectedNodeId;
  final CanvasMode mode;
  final double zoomLevel;
  final String? linkSourceNodeId; // First node tapped during link creation

  const CanvasViewState({
    this.selectedNodeId,
    this.mode = CanvasMode.view,
    this.zoomLevel = 1.0,
    this.linkSourceNodeId,
  });

  CanvasViewState copyWith({
    String? selectedNodeId,
    CanvasMode? mode,
    double? zoomLevel,
    String? linkSourceNodeId,
    bool clearLinkSource = false,
  }) {
    return CanvasViewState(
      selectedNodeId: selectedNodeId ?? this.selectedNodeId,
      mode: mode ?? this.mode,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      linkSourceNodeId: clearLinkSource ? null : (linkSourceNodeId ?? this.linkSourceNodeId),
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

  /// Starts link creation workflow by setting source node.
  void startLinkCreation(String sourceNodeId) {
    state = state.copyWith(
      mode: CanvasMode.createLink,
      linkSourceNodeId: sourceNodeId,
    );
  }

  /// Completes link creation and returns to view mode.
  void completeLinkCreation() {
    state = state.copyWith(
      mode: CanvasMode.view,
      clearLinkSource: true,
    );
  }

  /// Cancels link creation and returns to view mode.
  void cancelLinkCreation() {
    state = state.copyWith(
      mode: CanvasMode.view,
      clearLinkSource: true,
    );
  }

  /// Toggles link creation mode.
  void toggleLinkMode() {
    if (state.mode == CanvasMode.createLink) {
      cancelLinkCreation();
    } else {
      state = state.copyWith(mode: CanvasMode.createLink);
    }
  }
}

/// Provider for canvas view state.
final canvasViewProvider =
    StateNotifierProvider<CanvasViewNotifier, CanvasViewState>((ref) {
  return CanvasViewNotifier();
});
