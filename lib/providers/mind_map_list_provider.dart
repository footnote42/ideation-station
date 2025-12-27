import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideation_station/services/storage_service.dart';

/// State notifier for managing the list of saved mind maps.
///
/// Uses lazy loading - loads only metadata (id, name, timestamps) for efficient display.
/// Full mind map data is loaded on-demand when user opens a specific map.
class MindMapListNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final StorageService _storageService;

  MindMapListNotifier({StorageService? storageService})
      : _storageService = storageService ?? StorageService(),
        super([]);

  /// Load mind map metadata from storage.
  ///
  /// Uses index.json for fast loading (metadata only, not full maps).
  Future<void> loadMindMaps() async {
    try {
      final metadata = await _storageService.listMindMapMetadata();
      state = metadata;
    } catch (e) {
      // On error, set empty state
      state = [];
    }
  }

  /// Refresh the mind map list.
  ///
  /// Call this after saving/deleting a mind map to update the UI.
  Future<void> refresh() async {
    await loadMindMaps();
  }

  /// Get metadata for a single mind map by ID.
  ///
  /// Returns null if not found.
  Map<String, dynamic>? getMapMetadata(String id) {
    try {
      return state.firstWhere((map) => map['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Remove a mind map from the list (after deletion).
  void removeMap(String id) {
    state = state.where((map) => map['id'] != id).toList();
  }

  /// Update a mind map's metadata (after save/rename).
  void updateMapMetadata(Map<String, dynamic> metadata) {
    final id = metadata['id'] as String;

    // Remove existing entry
    final filtered = state.where((map) => map['id'] != id).toList();

    // Add updated entry
    filtered.add(metadata);

    // Re-sort by lastModifiedAt
    filtered.sort((a, b) {
      final aTime = DateTime.parse(a['lastModifiedAt'] as String);
      final bTime = DateTime.parse(b['lastModifiedAt'] as String);
      return bTime.compareTo(aTime); // Newest first
    });

    state = filtered;
  }
}

/// Provider for the list of saved mind maps.
///
/// Provides metadata-only list for efficient UI rendering.
/// Full mind map data should be loaded via StorageService when needed.
final mindMapListProvider =
    StateNotifierProvider<MindMapListNotifier, List<Map<String, dynamic>>>((ref) {
  return MindMapListNotifier();
});
