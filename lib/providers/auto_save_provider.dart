import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideation_station/models/mind_map.dart';
import 'package:ideation_station/providers/mind_map_provider.dart';
import 'package:ideation_station/services/storage_service.dart';

/// Auto-save mechanism with debouncing to prevent excessive file I/O.
///
/// Watches the mind map provider and automatically saves changes after a 500ms
/// delay (as per FR-025 and SC-013 performance requirements).
class AutoSaveNotifier extends StateNotifier<DateTime?> {
  final Ref _ref;
  final StorageService _storageService;
  Timer? _debounceTimer;

  AutoSaveNotifier(this._ref, {StorageService? storageService})
      : _storageService = storageService ?? StorageService(),
        super(null) {
    // Listen to mind map changes
    _ref.listen<MindMap?>(mindMapProvider, (previous, next) {
      if (next != null) {
        _scheduleSave(next);
      }
    });
  }

  /// Schedule a save operation with 500ms debounce
  void _scheduleSave(MindMap mindMap) {
    // Cancel existing timer
    _debounceTimer?.cancel();

    // Schedule new save after 500ms
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await _performSave(mindMap);
    });
  }

  /// Perform the actual save operation
  Future<void> _performSave(MindMap mindMap) async {
    try {
      await _storageService.saveMindMap(mindMap);
      state = DateTime.now(); // Update last save timestamp
    } catch (e) {
      // Log error but don't disrupt user flow
      // In production, this would use a logging service
    }
  }

  /// Manually trigger an immediate save (for explicit user actions)
  Future<void> saveNow() async {
    _debounceTimer?.cancel();

    final mindMap = _ref.read(mindMapProvider);
    if (mindMap != null) {
      await _performSave(mindMap);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

/// Provider for auto-save functionality
///
/// The state contains the timestamp of the last successful save,
/// or null if no save has occurred yet.
final autoSaveProvider = StateNotifierProvider<AutoSaveNotifier, DateTime?>((ref) {
  return AutoSaveNotifier(ref);
});
