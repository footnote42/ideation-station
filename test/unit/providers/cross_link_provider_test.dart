import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ideation_station/models/cross_link.dart';
import 'package:ideation_station/providers/mind_map_provider.dart';

void main() {
  group('CrossLink Creation Logic', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should create cross-link between two nodes', () {
      // Arrange
      final notifier = container.read(mindMapProvider.notifier);
      notifier.createMindMap(name: 'Test Map', centralText: 'Central');

      notifier.addBranchNode(text: 'Branch 1');
      notifier.addBranchNode(text: 'Branch 2');

      final branch1 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 1');
      final branch2 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 2');

      // Act
      notifier.addCrossLink(
        sourceNodeId: branch1.id,
        targetNodeId: branch2.id,
        label: 'relates to',
      );

      // Assert
      final crossLinks = notifier.state!.crossLinks;
      expect(crossLinks.length, 1);
      expect(crossLinks[0].sourceNodeId, branch1.id);
      expect(crossLinks[0].targetNodeId, branch2.id);
      expect(crossLinks[0].label, 'relates to');
    });

    test('should prevent self-links (node linking to itself)', () {
      // Arrange
      final notifier = container.read(mindMapProvider.notifier);
      notifier.createMindMap(name: 'Test Map', centralText: 'Central');

      notifier.addBranchNode(text: 'Branch 1');
      final branch1 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 1');

      // Act & Assert
      expect(
        () => notifier.addCrossLink(
          sourceNodeId: branch1.id,
          targetNodeId: branch1.id,
          label: 'self-link',
        ),
        throwsArgumentError,
        reason: 'Should not allow node to link to itself',
      );
    });

    test('should prevent duplicate cross-links between same nodes', () {
      // Arrange
      final notifier = container.read(mindMapProvider.notifier);
      notifier.createMindMap(name: 'Test Map', centralText: 'Central');

      notifier.addBranchNode(text: 'Branch 1');
      notifier.addBranchNode(text: 'Branch 2');

      final branch1 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 1');
      final branch2 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 2');

      // Create first cross-link
      notifier.addCrossLink(
        sourceNodeId: branch1.id,
        targetNodeId: branch2.id,
        label: 'first link',
      );

      // Act - try to create duplicate
      notifier.addCrossLink(
        sourceNodeId: branch1.id,
        targetNodeId: branch2.id,
        label: 'duplicate link',
      );

      // Assert - should still only have one link (duplicate prevention)
      final crossLinks = notifier.state!.crossLinks;
      expect(crossLinks.length, 1,
          reason: 'Duplicate cross-links should be prevented');
    });

    test('should allow bidirectional links (A->B and B->A)', () {
      // Arrange
      final notifier = container.read(mindMapProvider.notifier);
      notifier.createMindMap(name: 'Test Map', centralText: 'Central');

      notifier.addBranchNode(text: 'Branch 1');
      notifier.addBranchNode(text: 'Branch 2');

      final branch1 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 1');
      final branch2 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 2');

      // Act - create links in both directions
      notifier.addCrossLink(
        sourceNodeId: branch1.id,
        targetNodeId: branch2.id,
        label: 'forward',
      );

      notifier.addCrossLink(
        sourceNodeId: branch2.id,
        targetNodeId: branch1.id,
        label: 'backward',
      );

      // Assert
      final crossLinks = notifier.state!.crossLinks;
      expect(crossLinks.length, 2,
          reason: 'Bidirectional links should be allowed');
      expect(crossLinks[0].sourceNodeId, branch1.id);
      expect(crossLinks[1].sourceNodeId, branch2.id);
    });

    test('should validate that source and target nodes exist', () {
      // Arrange
      final notifier = container.read(mindMapProvider.notifier);
      notifier.createMindMap(name: 'Test Map', centralText: 'Central');

      // Act & Assert
      expect(
        () => notifier.addCrossLink(
          sourceNodeId: 'non-existent-1',
          targetNodeId: 'non-existent-2',
          label: 'invalid',
        ),
        throwsArgumentError,
        reason: 'Should validate that nodes exist',
      );
    });

    test('should allow cross-links with empty labels', () {
      // Arrange
      final notifier = container.read(mindMapProvider.notifier);
      notifier.createMindMap(name: 'Test Map', centralText: 'Central');

      notifier.addBranchNode(text: 'Branch 1');
      notifier.addBranchNode(text: 'Branch 2');

      final branch1 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 1');
      final branch2 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 2');

      // Act
      notifier.addCrossLink(
        sourceNodeId: branch1.id,
        targetNodeId: branch2.id,
        label: '',
      );

      // Assert
      final crossLinks = notifier.state!.crossLinks;
      expect(crossLinks.length, 1);
      expect(crossLinks[0].label, isEmpty);
    });

    test('should delete cross-link by id', () {
      // Arrange
      final notifier = container.read(mindMapProvider.notifier);
      notifier.createMindMap(name: 'Test Map', centralText: 'Central');

      notifier.addBranchNode(text: 'Branch 1');
      notifier.addBranchNode(text: 'Branch 2');

      final branch1 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 1');
      final branch2 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 2');

      notifier.addCrossLink(
        sourceNodeId: branch1.id,
        targetNodeId: branch2.id,
        label: 'to delete',
      );

      final linkId = notifier.state!.crossLinks[0].id;

      // Act
      notifier.deleteCrossLink(linkId);

      // Assert
      expect(notifier.state!.crossLinks, isEmpty);
    });

    test('should allow multiple cross-links from single node', () {
      // Arrange
      final notifier = container.read(mindMapProvider.notifier);
      notifier.createMindMap(name: 'Test Map', centralText: 'Central');

      notifier.addBranchNode(text: 'Branch 1');
      notifier.addBranchNode(text: 'Branch 2');
      notifier.addBranchNode(text: 'Branch 3');

      final branch1 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 1');
      final branch2 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 2');
      final branch3 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 3');

      // Act - create multiple links from branch1
      notifier.addCrossLink(
        sourceNodeId: branch1.id,
        targetNodeId: branch2.id,
        label: 'link 1',
      );

      notifier.addCrossLink(
        sourceNodeId: branch1.id,
        targetNodeId: branch3.id,
        label: 'link 2',
      );

      // Assert
      final crossLinks = notifier.state!.crossLinks;
      expect(crossLinks.length, 2);
      expect(crossLinks.where((l) => l.sourceNodeId == branch1.id).length, 2);
    });
  });
}
