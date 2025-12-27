import 'package:flutter_test/flutter_test.dart';
import 'package:ideation_station/models/cross_link.dart';

void main() {
  group('CrossLink Model Validation', () {
    test('should create a valid cross-link between two nodes', () {
      // Arrange & Act
      final crossLink = CrossLink(
        id: 'link-1',
        sourceNodeId: 'node-1',
        targetNodeId: 'node-2',
        label: 'relates to',
        createdAt: DateTime.now(),
      );

      // Assert
      expect(crossLink.id, 'link-1');
      expect(crossLink.sourceNodeId, 'node-1');
      expect(crossLink.targetNodeId, 'node-2');
      expect(crossLink.label, 'relates to');
      expect(crossLink.createdAt, isNotNull);
    });

    test('should allow empty label for unlabeled cross-links', () {
      // Arrange & Act
      final crossLink = CrossLink(
        id: 'link-1',
        sourceNodeId: 'node-1',
        targetNodeId: 'node-2',
        label: '',
        createdAt: DateTime.now(),
      );

      // Assert
      expect(crossLink.label, isEmpty);
    });

    test('should serialize to JSON correctly', () {
      // Arrange
      final now = DateTime.now();
      final crossLink = CrossLink(
        id: 'link-1',
        sourceNodeId: 'node-1',
        targetNodeId: 'node-2',
        label: 'causes',
        createdAt: now,
      );

      // Act
      final json = crossLink.toJson();

      // Assert
      expect(json['id'], 'link-1');
      expect(json['sourceNodeId'], 'node-1');
      expect(json['targetNodeId'], 'node-2');
      expect(json['label'], 'causes');
      expect(json['createdAt'], now.toIso8601String());
    });

    test('should deserialize from JSON correctly', () {
      // Arrange
      final now = DateTime.now();
      final json = {
        'id': 'link-1',
        'sourceNodeId': 'node-1',
        'targetNodeId': 'node-2',
        'label': 'influences',
        'createdAt': now.toIso8601String(),
      };

      // Act
      final crossLink = CrossLink.fromJson(json);

      // Assert
      expect(crossLink.id, 'link-1');
      expect(crossLink.sourceNodeId, 'node-1');
      expect(crossLink.targetNodeId, 'node-2');
      expect(crossLink.label, 'influences');
      expect(crossLink.createdAt.toIso8601String(), now.toIso8601String());
    });

    test('should support copyWith for immutability', () {
      // Arrange
      final original = CrossLink(
        id: 'link-1',
        sourceNodeId: 'node-1',
        targetNodeId: 'node-2',
        label: 'original',
        createdAt: DateTime.now(),
      );

      // Act
      final updated = original.copyWith(label: 'updated');

      // Assert
      expect(updated.id, 'link-1');
      expect(updated.sourceNodeId, 'node-1');
      expect(updated.targetNodeId, 'node-2');
      expect(updated.label, 'updated');
      expect(original.label, 'original', reason: 'Original should remain unchanged');
    });

    test('should handle label length limits', () {
      // Arrange - create cross-link with long label
      final longLabel = 'A' * 100;
      final crossLink = CrossLink(
        id: 'link-1',
        sourceNodeId: 'node-1',
        targetNodeId: 'node-2',
        label: longLabel,
        createdAt: DateTime.now(),
      );

      // Assert - model accepts long labels (UI should handle truncation)
      expect(crossLink.label?.length, 100);
    });

    test('should handle bidirectional links as separate entities', () {
      // Arrange - create two links between same nodes in opposite directions
      final link1 = CrossLink(
        id: 'link-1',
        sourceNodeId: 'node-A',
        targetNodeId: 'node-B',
        label: 'forward',
        createdAt: DateTime.now(),
      );

      final link2 = CrossLink(
        id: 'link-2',
        sourceNodeId: 'node-B',
        targetNodeId: 'node-A',
        label: 'backward',
        createdAt: DateTime.now(),
      );

      // Assert - links are distinct
      expect(link1.id, isNot(link2.id));
      expect(link1.sourceNodeId, link2.targetNodeId);
      expect(link1.targetNodeId, link2.sourceNodeId);
    });

    test('should support equality comparison', () {
      // Arrange
      final now = DateTime.now();
      final link1 = CrossLink(
        id: 'link-1',
        sourceNodeId: 'node-1',
        targetNodeId: 'node-2',
        label: 'same',
        createdAt: now,
      );

      final link2 = CrossLink(
        id: 'link-1',
        sourceNodeId: 'node-1',
        targetNodeId: 'node-2',
        label: 'same',
        createdAt: now,
      );

      // Assert - freezed provides equality
      expect(link1, equals(link2));
    });
  });
}
