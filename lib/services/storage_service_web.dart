import 'dart:convert';

import 'package:ideation_station/models/mind_map.dart';
import 'package:ideation_station/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Web-compatible storage service using SharedPreferences (browser localStorage).
///
/// This implementation provides the same interface as StorageService but works
/// on web platforms where dart:io is not available.
class StorageServiceWeb implements StorageServiceInterface {
  static const String _mindMapsPrefix = 'mind_map_';
  static const String _indexKey = 'mind_maps_index';

  @override
  Future<void> saveMindMap(MindMap mindMap) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert mind map to JSON
      final jsonData = mindMap.toJson();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);

      // Debug logging
      print('💾 SAVING MindMap: ${mindMap.name}');
      print('   - ID: ${mindMap.id}');
      print('   - Nodes count: ${mindMap.nodes.length}');
      print('   - Central node: ${mindMap.centralNode.text}');
      print('   - JSON preview: ${jsonString.substring(0, jsonString.length > 500 ? 500 : jsonString.length)}...');

      // Save to localStorage
      final key = '$_mindMapsPrefix${mindMap.id}';
      await prefs.setString(key, jsonString);

      // Update index
      await _updateIndex(mindMap);

      print('✅ SAVED successfully');
    } catch (e) {
      print('❌ SAVE FAILED: $e');
      throw Exception('Failed to save mind map: $e');
    }
  }

  @override
  Future<MindMap?> loadMindMap(String id) async {
    try {
      print('📂 LOADING MindMap: $id');
      final prefs = await SharedPreferences.getInstance();
      final key = '$_mindMapsPrefix$id';
      final jsonString = prefs.getString(key);

      if (jsonString == null) {
        print('❌ LOAD FAILED: Not found');
        return null;
      }

      print('   - JSON length: ${jsonString.length}');
      final jsonData = jsonDecode(jsonString);
      if (jsonData is! Map<String, dynamic>) {
        print('❌ LOAD FAILED: Invalid JSON structure');
        throw FormatException('Invalid JSON structure');
      }

      final mindMap = MindMap.fromJson(jsonData);
      print('✅ LOADED successfully');
      print('   - Name: ${mindMap.name}');
      print('   - Nodes count: ${mindMap.nodes.length}');
      print('   - Central node: ${mindMap.centralNode.text}');

      return mindMap;
    } catch (e) {
      print('❌ LOAD FAILED: $e');
      throw Exception('Failed to load mind map: $e');
    }
  }

  @override
  Future<void> renameMindMap(String id, String newName) async {
    try {
      final mindMap = await loadMindMap(id);
      if (mindMap == null) return;

      final updated = mindMap.copyWith(
        name: newName,
        lastModifiedAt: DateTime.now(),
      );

      await saveMindMap(updated);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<void> deleteMindMap(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_mindMapsPrefix$id';

      // Remove from localStorage
      await prefs.remove(key);

      // Remove from index
      await _removeFromIndex(id);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<List<MindMap>> listMindMaps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys()
          .where((k) => k.startsWith(_mindMapsPrefix))
          .toList();

      final mindMaps = <MindMap>[];

      for (final key in keys) {
        try {
          final jsonString = prefs.getString(key);
          if (jsonString != null) {
            final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
            final mindMap = MindMap.fromJson(jsonData);
            mindMaps.add(mindMap);
          }
        } catch (e) {
          // Skip corrupted entries
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

  @override
  Future<List<Map<String, dynamic>>> listMindMapMetadata() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final indexString = prefs.getString(_indexKey);

      if (indexString == null) {
        await _rebuildIndex();
        return listMindMapMetadata();
      }

      final indexData = jsonDecode(indexString) as Map<String, dynamic>;
      final maps = indexData['maps'] as List;

      // Sort by lastModifiedAt descending
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

  /// Update index with mind map metadata
  Future<void> _updateIndex(MindMap mindMap) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final indexString = prefs.getString(_indexKey);

      Map<String, dynamic> indexData;
      if (indexString != null) {
        indexData = jsonDecode(indexString) as Map<String, dynamic>;
      } else {
        indexData = {'maps': []};
      }

      final maps = indexData['maps'] as List;

      // Remove existing entry
      maps.removeWhere((m) => (m as Map)['id'] == mindMap.id);

      // Add new metadata
      maps.add({
        'id': mindMap.id,
        'name': mindMap.name,
        'createdAt': mindMap.createdAt.toIso8601String(),
        'lastModifiedAt': mindMap.lastModifiedAt.toIso8601String(),
      });

      // Save updated index
      final jsonString = const JsonEncoder.withIndent('  ').convert(indexData);
      await prefs.setString(_indexKey, jsonString);
    } catch (e) {
      // Silently fail
    }
  }

  /// Remove entry from index
  Future<void> _removeFromIndex(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final indexString = prefs.getString(_indexKey);

      if (indexString == null) return;

      final indexData = jsonDecode(indexString) as Map<String, dynamic>;
      final maps = indexData['maps'] as List;

      maps.removeWhere((m) => (m as Map)['id'] == id);

      final jsonString = const JsonEncoder.withIndent('  ').convert(indexData);
      await prefs.setString(_indexKey, jsonString);
    } catch (e) {
      // Silently fail
    }
  }

  /// Rebuild index by scanning all saved mind maps
  Future<void> _rebuildIndex() async {
    try {
      final mindMaps = await listMindMaps();
      final prefs = await SharedPreferences.getInstance();

      final maps = mindMaps.map((m) => {
        'id': m.id,
        'name': m.name,
        'createdAt': m.createdAt.toIso8601String(),
        'lastModifiedAt': m.lastModifiedAt.toIso8601String(),
      }).toList();

      final indexData = {'maps': maps};
      final jsonString = const JsonEncoder.withIndent('  ').convert(indexData);
      await prefs.setString(_indexKey, jsonString);
    } catch (e) {
      // Silently fail
    }
  }
}
