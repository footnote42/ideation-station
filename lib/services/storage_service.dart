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
    final appDocDir = await getApplicationDocumentsDirectory();
    final mindMapsDir = Directory('${appDocDir.path}/$_mindMapsDirectory');

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

      // Update index with metadata
      await _updateIndex(mindMap);
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

      // Remove from index
      await _removeFromIndex(id);
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
          .where((f) => f.path.endsWith('.json') && !f.path.endsWith('.tmp') && !f.path.endsWith('index.json'))
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

  /// List mind map metadata only (efficient for UI lists).
  ///
  /// Returns lightweight metadata (id, name, timestamps) from index.json.
  /// Significantly faster than loading full mind maps for large collections.
  Future<List<Map<String, dynamic>>> listMindMapMetadata() async {
    try {
      final dir = await _getMindMapsDirectory();
      final indexFile = File('${dir.path}/index.json');

      // Create index if it doesn't exist
      if (!indexFile.existsSync()) {
        await _rebuildIndex();
      }

      final indexContent = await indexFile.readAsString();
      final indexData = jsonDecode(indexContent) as Map<String, dynamic>;
      final maps = indexData['maps'] as List;

      // Sort by lastModifiedAt descending (newest first)
      final sortedMaps = maps.map((m) => m as Map<String, dynamic>).toList();
      sortedMaps.sort((a, b) {
        final aTime = DateTime.parse(a['lastModifiedAt'] as String);
        final bTime = DateTime.parse(b['lastModifiedAt'] as String);
        return bTime.compareTo(aTime);
      });

      return sortedMaps;
    } catch (e) {
      return [];
    }
  }

  /// Update index.json with mind map metadata.
  Future<void> _updateIndex(MindMap mindMap) async {
    try {
      final dir = await _getMindMapsDirectory();
      final indexFile = File('${dir.path}/index.json');

      Map<String, dynamic> indexData;

      if (indexFile.existsSync()) {
        final content = await indexFile.readAsString();
        indexData = jsonDecode(content) as Map<String, dynamic>;
      } else {
        indexData = {'maps': []};
      }

      final maps = indexData['maps'] as List;

      // Remove existing entry with same ID
      maps.removeWhere((m) => (m as Map)['id'] == mindMap.id);

      // Add new metadata entry
      maps.add({
        'id': mindMap.id,
        'name': mindMap.name,
        'createdAt': mindMap.createdAt.toIso8601String(),
        'lastModifiedAt': mindMap.lastModifiedAt.toIso8601String(),
      });

      // Write updated index
      final jsonString = const JsonEncoder.withIndent('  ').convert(indexData);
      await indexFile.writeAsString(jsonString);
    } catch (e) {
      // Silently fail - index is optimization, not critical
    }
  }

  /// Remove entry from index.json.
  Future<void> _removeFromIndex(String id) async {
    try {
      final dir = await _getMindMapsDirectory();
      final indexFile = File('${dir.path}/index.json');

      if (!indexFile.existsSync()) {
        return;
      }

      final content = await indexFile.readAsString();
      final indexData = jsonDecode(content) as Map<String, dynamic>;
      final maps = indexData['maps'] as List;

      maps.removeWhere((m) => (m as Map)['id'] == id);

      final jsonString = const JsonEncoder.withIndent('  ').convert(indexData);
      await indexFile.writeAsString(jsonString);
    } catch (e) {
      // Silently fail
    }
  }

  /// Rebuild index.json by scanning all saved mind maps.
  Future<void> _rebuildIndex() async {
    try {
      final mindMaps = await listMindMaps();
      final dir = await _getMindMapsDirectory();
      final indexFile = File('${dir.path}/index.json');

      final maps = mindMaps.map((m) => {
        'id': m.id,
        'name': m.name,
        'createdAt': m.createdAt.toIso8601String(),
        'lastModifiedAt': m.lastModifiedAt.toIso8601String(),
      }).toList();

      final indexData = {'maps': maps};
      final jsonString = const JsonEncoder.withIndent('  ').convert(indexData);
      await indexFile.writeAsString(jsonString);
    } catch (e) {
      // Silently fail
    }
  }
}
