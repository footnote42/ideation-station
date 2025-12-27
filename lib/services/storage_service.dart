import 'dart:convert';
import 'dart:io';

import 'package:ideation_station/models/mind_map.dart';
import 'package:path_provider/path_provider.dart';

/// Service for persisting mind maps to local device storage.
///
/// Uses path_provider for cross-platform file system access.
/// Implements atomic file writes for crash safety.
class StorageService {
  static const String _mindMapsDirectory = 'mind_maps';

  /// Get the directory where mind maps are stored
  Future<Directory> _getMindMapsDirectory() async {
    final appDocDir = await getApplicationDocumentsPath();
    final mindMapsDir = Directory('$appDocDir/$_mindMapsDirectory');

    if (!mindMapsDir.existsSync()) {
      await mindMapsDir.create(recursive: true);
    }

    return mindMapsDir;
  }

  /// Save a mind map to local storage
  ///
  /// Uses atomic write pattern (write to temp file, then rename) for safety.
  /// If a mind map with the same ID already exists, it will be overwritten.
  Future<void> saveMindMap(MindMap mindMap) async {
    final dir = await _getMindMapsDirectory();
    final file = File('${dir.path}/${mindMap.id}.json');
    final tempFile = File('${dir.path}/${mindMap.id}.json.tmp');

    try {
      // Convert mind map to JSON
      final jsonData = mindMap.toJson();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);

      // Write to temp file first (atomic write pattern)
      await tempFile.writeAsString(jsonString);

      // Rename temp file to actual file (atomic operation)
      await tempFile.rename(file.path);
    } catch (e) {
      // Clean up temp file if it exists
      if (tempFile.existsSync()) {
        await tempFile.delete();
      }
      rethrow;
    }
  }

  /// Load a mind map from local storage by ID
  ///
  /// Returns null if the mind map doesn't exist or cannot be loaded.
  Future<MindMap?> loadMindMap(String id) async {
    try {
      final dir = await _getMindMapsDirectory();
      final file = File('${dir.path}/$id.json');

      if (!file.existsSync()) {
        return null;
      }

      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

      return MindMap.fromJson(jsonData);
    } catch (e) {
      // If JSON parsing fails or file is corrupted, return null
      return null;
    }
  }

  /// Delete a mind map from local storage
  ///
  /// Does nothing if the mind map doesn't exist.
  Future<void> deleteMindMap(String id) async {
    try {
      final dir = await _getMindMapsDirectory();
      final file = File('${dir.path}/$id.json');

      if (file.existsSync()) {
        await file.delete();
      }
    } catch (e) {
      // Silently fail if deletion doesn't work
      // (file might not exist or permissions issue)
    }
  }

  /// List all saved mind maps
  ///
  /// Returns a list of MindMap objects sorted by last modified date (newest first).
  Future<List<MindMap>> listMindMaps() async {
    try {
      final dir = await _getMindMapsDirectory();

      if (!dir.existsSync()) {
        return [];
      }

      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json') && !f.path.endsWith('.tmp'))
          .toList();

      final mindMaps = <MindMap>[];

      for (final file in files) {
        try {
          final jsonString = await file.readAsString();
          final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
          final mindMap = MindMap.fromJson(jsonData);
          mindMaps.add(mindMap);
        } catch (e) {
          // Skip corrupted files
          continue;
        }
      }

      // Sort by last modified date (newest first)
      mindMaps.sort((a, b) => b.lastModifiedAt.compareTo(a.lastModifiedAt));

      return mindMaps;
    } catch (e) {
      return [];
    }
  }
}
