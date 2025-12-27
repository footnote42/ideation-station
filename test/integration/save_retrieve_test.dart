import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ideation_station/models/mind_map.dart';
import 'package:ideation_station/models/node.dart';
import 'package:ideation_station/models/node_type.dart';
import 'package:ideation_station/models/position.dart';
import 'package:ideation_station/providers/mind_map_provider.dart';
import 'package:ideation_station/services/storage_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Mock implementation of PathProviderPlatform for testing.
class MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final String? _testPath;

  MockPathProviderPlatform(this._testPath);

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return _testPath;
  }
}

/// Integration test for User Story 4 (T091): Save & Retrieve Mind Maps
///
/// Tests the complete user journey:
/// 1. Create a mind map with central node and branches
/// 2. Save to local storage
/// 3. Simulate app close (clear in-memory state)
/// 4. Reload from storage
/// 5. Verify all data is intact (SC-011)
void main() {
  late Directory testDir;
  late StorageService storageService;

  setUp(() async {
    // Create unique test directory
    testDir = await Directory.systemTemp.createTemp('ideation_station_test_');

    // Register mock PathProviderPlatform
    PathProviderPlatform.instance = MockPathProviderPlatform(testDir.path);

    storageService = StorageService();
  });

  tearDown(() async {
    // Clean up test directory
    if (testDir.existsSync()) {
      await testDir.delete(recursive: true);
    }
  });

  group('User Story 4: Save & Retrieve Integration Test (T091)', () {
    test('should persist and restore complete mind map (SC-011)', () async {
      // ========================================
      // STEP 1: Create mind map with content
      // ========================================
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final mindMapNotifier = container.read(mindMapProvider.notifier);

      // Create mind map with central node
      mindMapNotifier.createMindMap(
        name: 'Project Ideas',
        centralText: 'Innovation',
      );

      expect(mindMapNotifier.state, isNotNull, reason: 'Mind map should be created');
      expect(mindMapNotifier.state!.name, 'Project Ideas');
      expect(mindMapNotifier.state!.centralNode.text, 'Innovation');

      final originalMapId = mindMapNotifier.state!.id;
      final centralNodeId = mindMapNotifier.state!.centralNode.id;

      // Add branch nodes
      mindMapNotifier.addBranchNode(text: 'Technology');
      mindMapNotifier.addBranchNode(text: 'Design');
      mindMapNotifier.addBranchNode(text: 'Marketing');

      expect(mindMapNotifier.state!.nodes.length, 4,
          reason: 'Should have central + 3 branches');

      // Add sub-branch to first branch
      final firstBranchId = mindMapNotifier.state!.nodes
          .firstWhere((n) => n.type == NodeType.branch && n.text == 'Technology')
          .id;
      mindMapNotifier.addSubBranch(
        parentId: firstBranchId,
        text: 'AI',
      );

      expect(mindMapNotifier.state!.nodes.length, 5,
          reason: 'Should have central + 3 branches + 1 sub-branch');

      final mindMap = mindMapNotifier.state!;

      // ========================================
      // STEP 2: Save to storage
      // ========================================
      await storageService.saveMindMap(mindMap);

      // Verify file exists
      final mindMapFile = File('${testDir.path}/mind_maps/${mindMap.id}.json');
      expect(mindMapFile.existsSync(), isTrue,
          reason: 'Mind map file should exist after save');

      // Verify index.json was created
      final indexFile = File('${testDir.path}/mind_maps/index.json');
      expect(indexFile.existsSync(), isTrue,
          reason: 'Index file should be created');

      // ========================================
      // STEP 3: Simulate app close (clear state)
      // ========================================
      container.dispose();

      // Verify state is cleared
      final newContainer = ProviderContainer();
      addTearDown(newContainer.dispose);

      final newNotifier = newContainer.read(mindMapProvider.notifier);
      expect(newNotifier.state, isNull,
          reason: 'Mind map should be null after state clear');

      // ========================================
      // STEP 4: Reload from storage
      // ========================================
      final loadedMindMap = await storageService.loadMindMap(originalMapId);

      expect(loadedMindMap, isNotNull,
          reason: 'Mind map should be loaded from storage');

      // Load into provider
      newNotifier.loadMindMap(loadedMindMap!);

      expect(newNotifier.state, isNotNull,
          reason: 'Mind map should be restored in provider');

      final restoredMindMap = newNotifier.state!;

      // ========================================
      // STEP 5: Verify all data intact (SC-011)
      // ========================================

      // Verify top-level properties
      expect(restoredMindMap.id, originalMapId,
          reason: 'ID should be preserved');
      expect(restoredMindMap.name, 'Project Ideas',
          reason: 'Name should be preserved');
      expect(restoredMindMap.createdAt, mindMap.createdAt,
          reason: 'Creation timestamp should be preserved');
      expect(restoredMindMap.lastModifiedAt, mindMap.lastModifiedAt,
          reason: 'Last modified timestamp should be preserved');

      // Verify central node
      expect(restoredMindMap.centralNode.id, centralNodeId,
          reason: 'Central node ID should be preserved');
      expect(restoredMindMap.centralNode.text, 'Innovation',
          reason: 'Central node text should be preserved');
      expect(restoredMindMap.centralNode.type, NodeType.central,
          reason: 'Central node type should be preserved');

      // Verify node count
      expect(restoredMindMap.nodes.length, 5,
          reason: 'All nodes should be preserved');

      // Verify branch nodes
      final branchNodes = restoredMindMap.nodes
          .where((n) => n.type == NodeType.branch)
          .toList();
      expect(branchNodes.length, 3, reason: 'All 3 branches should be present');
      expect(
          branchNodes.any((n) => n.text == 'Technology'), isTrue,
          reason: 'Technology branch should exist');
      expect(
          branchNodes.any((n) => n.text == 'Design'), isTrue,
          reason: 'Design branch should exist');
      expect(
          branchNodes.any((n) => n.text == 'Marketing'), isTrue,
          reason: 'Marketing branch should exist');

      // Verify sub-branch
      final subBranchNodes = restoredMindMap.nodes
          .where((n) => n.type == NodeType.subBranch)
          .toList();
      expect(subBranchNodes.length, 1, reason: 'Sub-branch should be present');
      expect(subBranchNodes.first.text, 'AI',
          reason: 'Sub-branch text should be preserved');

      // Verify parent-child relationships
      final techBranch = restoredMindMap.nodes
          .firstWhere((n) => n.type == NodeType.branch && n.text == 'Technology');
      final aiSubBranch =
          restoredMindMap.nodes.firstWhere((n) => n.text == 'AI');
      expect(techBranch.childIds.contains(aiSubBranch.id), isTrue,
          reason: 'Parent should reference child');
      expect(aiSubBranch.parentId, techBranch.id,
          reason: 'Child should reference parent');

      // Verify positions are preserved
      expect(restoredMindMap.centralNode.position, const Position(x: 0, y: 0),
          reason: 'Central node position should be (0, 0)');

      // Verify colors are preserved
      expect(restoredMindMap.centralNode.color, isNotNull,
          reason: 'Colors should be preserved');
    });

    test('should handle multiple mind maps independently', () async {
      // Create first mind map
      final container1 = ProviderContainer();
      addTearDown(container1.dispose);

      container1.read(mindMapProvider.notifier).createMindMap(
            name: 'Work Project',
            centralText: 'Q1 Goals',
          );

      final mindMap1 = container1.read(mindMapProvider)!;
      container1.read(mindMapProvider.notifier).addBranchNode(text: 'Sales');

      await storageService.saveMindMap(mindMap1);

      // Create second mind map
      final container2 = ProviderContainer();
      addTearDown(container2.dispose);

      container2.read(mindMapProvider.notifier).createMindMap(
            name: 'Personal Goals',
            centralText: 'Health',
          );

      final mindMap2 = container2.read(mindMapProvider)!;
      container2.read(mindMapProvider.notifier).addBranchNode(text: 'Fitness');

      await storageService.saveMindMap(mindMap2);

      // Verify both can be loaded independently
      final loaded1 = await storageService.loadMindMap(mindMap1.id);
      final loaded2 = await storageService.loadMindMap(mindMap2.id);

      expect(loaded1, isNotNull);
      expect(loaded2, isNotNull);
      expect(loaded1!.id, mindMap1.id);
      expect(loaded2!.id, mindMap2.id);
      expect(loaded1.name, 'Work Project');
      expect(loaded2.name, 'Personal Goals');
      expect(loaded1.centralNode.text, 'Q1 Goals');
      expect(loaded2.centralNode.text, 'Health');
    });

    test('should list all saved mind maps sorted by lastModified', () async {
      // Create and save 3 mind maps with delays
      final maps = <MindMap>[];

      for (int i = 0; i < 3; i++) {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(mindMapProvider.notifier).createMindMap(
              name: 'Map $i',
              centralText: 'Idea $i',
            );

        final mindMap = container.read(mindMapProvider)!;
        maps.add(mindMap);

        await storageService.saveMindMap(mindMap);

        // Small delay to ensure different timestamps
        await Future.delayed(const Duration(milliseconds: 10));
      }

      // Load metadata
      final metadata = await storageService.listMindMapMetadata();

      // Verify all maps are listed
      expect(metadata.length, 3, reason: 'All 3 maps should be listed');

      // Verify sorted by lastModified (newest first)
      final timestamps = metadata
          .map((m) => DateTime.parse(m['lastModifiedAt'] as String))
          .toList();

      for (int i = 0; i < timestamps.length - 1; i++) {
        expect(timestamps[i].isAfter(timestamps[i + 1]) ||
            timestamps[i].isAtSameMomentAs(timestamps[i + 1]), isTrue,
            reason: 'Maps should be sorted newest first');
      }

      // Verify most recent map is first
      expect(metadata.first['name'], 'Map 2',
          reason: 'Most recently saved map should be first');
    });

    test('should handle data corruption gracefully', () async {
      // Create a corrupted JSON file
      final dir = Directory('${testDir.path}/mind_maps');
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }

      final corruptedFile = File('${dir.path}/corrupted.json');
      await corruptedFile.writeAsString('{ "invalid": "json structure" }');

      // Attempt to load corrupted file
      expect(
        () => storageService.loadMindMap('corrupted'),
        throwsA(isA<Exception>()),
        reason: 'Should throw exception for corrupted data',
      );
    });

    test('should create backup before deletion', () async {
      // Create and save a mind map
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(mindMapProvider.notifier).createMindMap(
            name: 'To Be Deleted',
            centralText: 'Backup Test',
          );

      final mindMap = container.read(mindMapProvider)!;
      await storageService.saveMindMap(mindMap);

      // Delete the mind map
      await storageService.deleteMindMap(mindMap.id);

      // Verify backup was created
      final backupsDir = Directory('${testDir.path}/mind_maps/backups');
      expect(backupsDir.existsSync(), isTrue,
          reason: 'Backups directory should exist');

      final backupFiles = backupsDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.contains(mindMap.id))
          .toList();

      expect(backupFiles.isNotEmpty, isTrue,
          reason: 'Backup file should exist');

      // Verify original file is deleted
      final originalFile = File('${testDir.path}/mind_maps/${mindMap.id}.json');
      expect(originalFile.existsSync(), isFalse,
          reason: 'Original file should be deleted');
    });
  });
}
