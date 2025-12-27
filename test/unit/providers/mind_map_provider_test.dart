import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ideation_station/models/mind_map.dart';
import 'package:ideation_station/models/node.dart';
import 'package:ideation_station/models/node_type.dart';
import 'package:ideation_station/models/position.dart';
import 'package:ideation_station/providers/mind_map_provider.dart';

void main() {
  group('MindMapProvider Color Propagation', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should propagate color to immediate children when parent color changes', () {
      // Arrange
      final notifier = container.read(mindMapProvider.notifier);

      // Create mind map with central node
      notifier.createMindMap(name: 'Test Map', centralText: 'Central');

      // Add branch nodes
      final centralId = notifier.state!.centralNode.id;
      notifier.addBranchNode(text: 'Branch 1');
      notifier.addBranchNode(text: 'Branch 2');

      final branch1 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 1');
      final branch2 = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch 2');

      // Act - change branch1 color
      notifier.updateNodeColor(branch1.id, Colors.red);

      // Assert
      final updatedMap = notifier.state!;
      final updatedBranch1 = updatedMap.nodes.firstWhere((n) => n.id == branch1.id);

      expect(updatedBranch1.color.toARGB32(), Colors.red.toARGB32(),
          reason: 'Parent node should have new color');

      // Branch2 should not be affected
      final updatedBranch2 = updatedMap.nodes.firstWhere((n) => n.id == branch2.id);
      expect(updatedBranch2.color.toARGB32(), isNot(Colors.red.toARGB32()),
          reason: 'Sibling node should not be affected');
    });

    test('should recursively propagate color to all descendants', () {
      // Arrange
      final notifier = container.read(mindMapProvider.notifier);
      notifier.createMindMap(name: 'Test Map', centralText: 'Central');

      final centralId = notifier.state!.centralNode.id;

      // Create tree: Central -> Branch -> SubBranch1, SubBranch2
      notifier.addBranchNode(text: 'Branch');
      final branch = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch');

      notifier.addSubBranch(parentId: branch.id, text: 'SubBranch 1');
      notifier.addSubBranch(parentId: branch.id, text: 'SubBranch 2');

      // Act - change branch color (should propagate to both sub-branches)
      notifier.updateNodeColor(branch.id, Colors.green);

      // Assert
      final updatedMap = notifier.state!;
      final updatedBranch = updatedMap.nodes.firstWhere((n) => n.id == branch.id);
      final subBranch1 = updatedMap.nodes.firstWhere((n) => n.text == 'SubBranch 1');
      final subBranch2 = updatedMap.nodes.firstWhere((n) => n.text == 'SubBranch 2');

      expect(updatedBranch.color.toARGB32(), Colors.green.toARGB32(),
          reason: 'Branch should have new color');
      expect(subBranch1.color.toARGB32(), Colors.green.toARGB32(),
          reason: 'SubBranch 1 should inherit parent color');
      expect(subBranch2.color.toARGB32(), Colors.green.toARGB32(),
          reason: 'SubBranch 2 should inherit parent color');
    });

    test('should propagate color through multiple levels of hierarchy', () {
      // Arrange
      final notifier = container.read(mindMapProvider.notifier);
      notifier.createMindMap(name: 'Test Map', centralText: 'Central');

      final centralId = notifier.state!.centralNode.id;

      // Create 3-level tree: Central -> Branch -> SubBranch -> DeepSubBranch
      notifier.addBranchNode(text: 'Branch');
      final branch = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch');

      notifier.addSubBranch(parentId: branch.id, text: 'SubBranch');
      final subBranch = notifier.state!.nodes.firstWhere((n) => n.text == 'SubBranch');

      notifier.addSubBranch(parentId: subBranch.id, text: 'DeepSubBranch');

      // Act - change branch color (should propagate all the way down)
      notifier.updateNodeColor(branch.id, Colors.purple);

      // Assert
      final updatedMap = notifier.state!;
      final updatedBranch = updatedMap.nodes.firstWhere((n) => n.id == branch.id);
      final updatedSubBranch = updatedMap.nodes.firstWhere((n) => n.id == subBranch.id);
      final deepSubBranch = updatedMap.nodes.firstWhere((n) => n.text == 'DeepSubBranch');

      expect(updatedBranch.color.toARGB32(), Colors.purple.toARGB32());
      expect(updatedSubBranch.color.toARGB32(), Colors.purple.toARGB32());
      expect(deepSubBranch.color.toARGB32(), Colors.purple.toARGB32(),
          reason: 'Color should propagate through all levels');
    });

    test('should not propagate color upward to parent nodes', () {
      // Arrange
      final notifier = container.read(mindMapProvider.notifier);
      notifier.createMindMap(name: 'Test Map', centralText: 'Central');

      final centralId = notifier.state!.centralNode.id;

      notifier.addBranchNode(text: 'Branch');
      final branch = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch');

      notifier.addSubBranch(parentId: branch.id, text: 'SubBranch');
      final subBranch = notifier.state!.nodes.firstWhere((n) => n.text == 'SubBranch');

      final originalCentralColor = notifier.state!.centralNode.color;
      final originalBranchColor = branch.color;

      // Act - change sub-branch color
      notifier.updateNodeColor(subBranch.id, Colors.orange);

      // Assert
      final updatedMap = notifier.state!;
      final updatedCentral = updatedMap.centralNode;
      final updatedBranch = updatedMap.nodes.firstWhere((n) => n.id == branch.id);

      expect(updatedCentral.color.toARGB32(), originalCentralColor.toARGB32(),
          reason: 'Central node color should not change');
      expect(updatedBranch.color.toARGB32(), originalBranchColor.toARGB32(),
          reason: 'Parent branch color should not change');
    });

    test('should handle color propagation with multiple children correctly', () {
      // Arrange
      final notifier = container.read(mindMapProvider.notifier);
      notifier.createMindMap(name: 'Test Map', centralText: 'Central');

      final centralId = notifier.state!.centralNode.id;

      // Create tree with multiple children:
      // Central -> Branch -> [Sub1, Sub2, Sub3]
      notifier.addBranchNode(text: 'Branch');
      final branch = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch');

      notifier.addSubBranch(parentId: branch.id, text: 'Sub1');
      notifier.addSubBranch(parentId: branch.id, text: 'Sub2');
      notifier.addSubBranch(parentId: branch.id, text: 'Sub3');

      // Act - change branch color
      notifier.updateNodeColor(branch.id, Colors.teal);

      // Assert - all children should have the new color
      final updatedMap = notifier.state!;
      final children = updatedMap.nodes.where(
        (n) => ['Sub1', 'Sub2', 'Sub3'].contains(n.text),
      ).toList();

      expect(children.length, 3);
      for (final child in children) {
        expect(child.color.toARGB32(), Colors.teal.toARGB32(),
            reason: '${child.text} should inherit parent color');
      }
    });

    test('should preserve other node properties during color propagation', () {
      // Arrange
      final notifier = container.read(mindMapProvider.notifier);
      notifier.createMindMap(name: 'Test Map', centralText: 'Central');

      final centralId = notifier.state!.centralNode.id;

      notifier.addBranchNode(text: 'Branch');
      final branch = notifier.state!.nodes.firstWhere((n) => n.text == 'Branch');

      final originalText = branch.text;
      final originalPosition = branch.position;
      final originalType = branch.type;

      // Act - change color
      notifier.updateNodeColor(branch.id, Colors.amber);

      // Assert - other properties should remain unchanged
      final updatedBranch = notifier.state!.nodes.firstWhere((n) => n.id == branch.id);

      expect(updatedBranch.text, originalText);
      expect(updatedBranch.position.x, originalPosition.x);
      expect(updatedBranch.position.y, originalPosition.y);
      expect(updatedBranch.type, originalType);
      expect(updatedBranch.color.toARGB32(), Colors.amber.toARGB32(),
          reason: 'Only color should change');
    });
  });
}
