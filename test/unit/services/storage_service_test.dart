import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ideation_station/models/mind_map.dart';
import 'package:ideation_station/models/node.dart';
import 'package:ideation_station/models/node_type.dart';
import 'package:ideation_station/models/position.dart';
import 'package:ideation_station/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// Mock PathProviderPlatform for testing
class MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return Directory.systemTemp.createTemp('test_storage').then((dir) => dir.path);
  }
}

void main() {
  late StorageService storageService;
  late Directory testDir;

  setUp(() async {
    // Register mock path provider
    PathProviderPlatform.instance = MockPathProviderPlatform();

    // Create test directory
    testDir = await Directory.systemTemp.createTemp('test_storage');

    // Initialize storage service
    storageService = StorageService();
  });

  tearDown(() async {
    // Clean up test directory
    if (testDir.existsSync()) {
      await testDir.delete(recursive: true);
    }
  });

  group('StorageService JSON Serialization', () {
    test('should save mind map to file system', () async {
      // Arrange
      final centralNode = Node(
        id: 'central-1',
        text: 'Main Idea',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
        symbols: [],
        childIds: [],
      );

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Test Mind Map',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
        centralNode: centralNode,
        nodes: [centralNode],
        crossLinks: [],
      );

      // Act
      await storageService.saveMindMap(mindMap);

      // Assert - file should exist
      final file = File('${testDir.path}/map-1.json');
      expect(file.existsSync(), isTrue, reason: 'Mind map file should be created');
    });

    test('should load mind map from file system', () async {
      // Arrange
      final centralNode = Node(
        id: 'central-1',
        text: 'Main Idea',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.green,
        symbols: [],
        childIds: [],
      );

      final originalMap = MindMap(
        id: 'map-2',
        name: 'Loadable Map',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
        centralNode: centralNode,
        nodes: [centralNode],
        crossLinks: [],
      );

      // Act
      await storageService.saveMindMap(originalMap);
      final loadedMap = await storageService.loadMindMap('map-2');

      // Assert
      expect(loadedMap, isNotNull, reason: 'Mind map should be loaded');
      expect(loadedMap!.id, 'map-2');
      expect(loadedMap.name, 'Loadable Map');
      expect(loadedMap.centralNode.text, 'Main Idea');
      expect(loadedMap.centralNode.color.toARGB32(), Colors.green.toARGB32());
    });

    test('should return null when loading non-existent mind map', () async {
      // Act
      final result = await storageService.loadMindMap('non-existent');

      // Assert
      expect(result, isNull, reason: 'Loading non-existent map should return null');
    });

    test('should preserve all node properties during save/load cycle', () async {
      // Arrange
      final centralNode = Node(
        id: 'central-1',
        text: 'Central',
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
        symbols: [],
        childIds: ['branch-1'],
      );

      final branchNode = Node(
        id: 'branch-1',
        text: 'Branch',
        type: NodeType.branch,
        position: const Position(x: 150, y: 0),
        color: Colors.red,
        symbols: [],
        parentId: 'central-1',
        childIds: [],
      );

      final mindMap = MindMap(
        id: 'map-3',
        name: 'Complex Map',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
        centralNode: centralNode,
        nodes: [centralNode, branchNode],
        crossLinks: [],
      );

      // Act
      await storageService.saveMindMap(mindMap);
      final loadedMap = await storageService.loadMindMap('map-3');

      // Assert
      expect(loadedMap, isNotNull);
      expect(loadedMap!.nodes.length, 2);

      final loadedBranch = loadedMap.nodes.firstWhere((n) => n.id == 'branch-1');
      expect(loadedBranch.text, 'Branch');
      expect(loadedBranch.type, NodeType.branch);
      expect(loadedBranch.position.x, 150);
      expect(loadedBranch.position.y, 0);
      expect(loadedBranch.color.toARGB32(), Colors.red.toARGB32());
      expect(loadedBranch.parentId, 'central-1');
    });

    test('should handle multiple mind maps independently', () async {
      // Arrange
      final map1 = _createTestMindMap('map-1', 'First Map');
      final map2 = _createTestMindMap('map-2', 'Second Map');

      // Act
      await storageService.saveMindMap(map1);
      await storageService.saveMindMap(map2);

      final loaded1 = await storageService.loadMindMap('map-1');
      final loaded2 = await storageService.loadMindMap('map-2');

      // Assert
      expect(loaded1!.name, 'First Map');
      expect(loaded2!.name, 'Second Map');
      expect(loaded1.id, 'map-1');
      expect(loaded2.id, 'map-2');
    });

    test('should delete mind map file', () async {
      // Arrange
      final mindMap = _createTestMindMap('map-delete', 'Delete Me');
      await storageService.saveMindMap(mindMap);

      // Act
      await storageService.deleteMindMap('map-delete');

      // Assert
      final loadedMap = await storageService.loadMindMap('map-delete');
      expect(loadedMap, isNull, reason: 'Deleted map should not be loadable');
    });

    test('should list all saved mind maps', () async {
      // Arrange
      final map1 = _createTestMindMap('list-1', 'List Map 1');
      final map2 = _createTestMindMap('list-2', 'List Map 2');
      final map3 = _createTestMindMap('list-3', 'List Map 3');

      await storageService.saveMindMap(map1);
      await storageService.saveMindMap(map2);
      await storageService.saveMindMap(map3);

      // Act
      final maps = await storageService.listMindMaps();

      // Assert
      expect(maps.length, greaterThanOrEqualTo(3));
      expect(maps.any((m) => m.id == 'list-1'), isTrue);
      expect(maps.any((m) => m.id == 'list-2'), isTrue);
      expect(maps.any((m) => m.id == 'list-3'), isTrue);
    });
  });
}

// Helper function to create test mind map
MindMap _createTestMindMap(String id, String name) {
  final centralNode = Node(
    id: '$id-central',
    text: name,
    type: NodeType.central,
    position: const Position(x: 0, y: 0),
    color: Colors.blue,
    symbols: [],
    childIds: [],
  );

  return MindMap(
    id: id,
    name: name,
    createdAt: DateTime.now(),
    lastModifiedAt: DateTime.now(),
    centralNode: centralNode,
    nodes: [centralNode],
    crossLinks: [],
  );
}
