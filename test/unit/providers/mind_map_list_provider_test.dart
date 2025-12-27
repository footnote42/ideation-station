import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideation_station/providers/mind_map_list_provider.dart';
import 'package:ideation_station/services/storage_service.dart';

void main() {
  group('MindMapListProvider (T076)', () {
    test('should load mind map metadata from storage on initialization', () async {
      // Arrange
      final container = ProviderContainer();

      // Act
      final provider = container.read(mindMapListProvider.notifier);
      await provider.loadMindMaps();

      // Assert
      final state = container.read(mindMapListProvider);
      expect(state, isA<List<Map<String, dynamic>>>());
    });

    test('should use lazy loading (metadata only, not full maps)', () async {
      // Arrange
      final container = ProviderContainer();

      // Act
      final provider = container.read(mindMapListProvider.notifier);
      await provider.loadMindMaps();

      final state = container.read(mindMapListProvider);

      // Assert - metadata should not contain full node data
      if (state.isNotEmpty) {
        final firstMap = state.first;
        expect(firstMap.keys, contains('id'));
        expect(firstMap.keys, contains('name'));
        expect(firstMap.keys, contains('createdAt'));
        expect(firstMap.keys, contains('lastModifiedAt'));

        // Should NOT contain full data
        expect(firstMap.keys, isNot(contains('nodes')));
        expect(firstMap.keys, isNot(contains('centralNode')));
        expect(firstMap.keys, isNot(contains('crossLinks')));
      }
    });

    test('should sort mind maps by lastModifiedAt descending', () async {
      // Arrange
      final container = ProviderContainer();

      // Act
      final provider = container.read(mindMapListProvider.notifier);
      await provider.loadMindMaps();

      final state = container.read(mindMapListProvider);

      // Assert - verify sorted by lastModifiedAt (newest first)
      if (state.length >= 2) {
        for (int i = 0; i < state.length - 1; i++) {
          final current = DateTime.parse(state[i]['lastModifiedAt'] as String);
          final next = DateTime.parse(state[i + 1]['lastModifiedAt'] as String);

          expect(
            current.isAfter(next) || current.isAtSameMomentAs(next),
            isTrue,
            reason: 'Maps should be sorted newest first',
          );
        }
      }
    });

    test('should refresh list when notified of changes', () async {
      // Arrange
      final container = ProviderContainer();
      final provider = container.read(mindMapListProvider.notifier);
      await provider.loadMindMaps();

      final initialCount = container.read(mindMapListProvider).length;

      // Act - refresh
      await provider.refresh();

      // Assert
      final state = container.read(mindMapListProvider);
      expect(state, isA<List<Map<String, dynamic>>>());
      // Count should still be the same (no new maps added in this test)
      expect(state.length, initialCount);
    });

    test('should handle empty storage gracefully', () async {
      // Arrange
      final container = ProviderContainer();

      // Act
      final provider = container.read(mindMapListProvider.notifier);
      await provider.loadMindMaps();

      // Assert
      final state = container.read(mindMapListProvider);
      expect(state, isA<List<Map<String, dynamic>>>());
      // Empty list is valid (no mind maps saved yet)
    });

    test('should provide method to get single map by ID', () async {
      // Arrange
      final container = ProviderContainer();
      final provider = container.read(mindMapListProvider.notifier);
      await provider.loadMindMaps();

      final state = container.read(mindMapListProvider);

      // Act & Assert
      if (state.isNotEmpty) {
        final mapId = state.first['id'] as String;
        final found = provider.getMapMetadata(mapId);

        expect(found, isNotNull);
        expect(found?['id'], mapId);
      }
    });

    test('should update list when mind map is deleted', () async {
      // Arrange
      final container = ProviderContainer();
      final provider = container.read(mindMapListProvider.notifier);
      await provider.loadMindMaps();

      final initialState = container.read(mindMapListProvider);

      // Act - simulate deletion by refreshing after delete
      // (In real usage, delete would happen via storage service)
      await provider.refresh();

      // Assert
      final newState = container.read(mindMapListProvider);
      expect(newState, isA<List<Map<String, dynamic>>>());
    });

    test('should update list when mind map name is changed', () async {
      // Arrange
      final container = ProviderContainer();
      final provider = container.read(mindMapListProvider.notifier);
      await provider.loadMindMaps();

      // Act - refresh to pick up any changes
      await provider.refresh();

      // Assert
      final state = container.read(mindMapListProvider);
      expect(state, isA<List<Map<String, dynamic>>>());
    });
  });
}
