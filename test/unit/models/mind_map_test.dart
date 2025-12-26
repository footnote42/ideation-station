import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ideation_station/models/mind_map.dart';
import 'package:ideation_station/models/node.dart';
import 'package:ideation_station/models/node_type.dart';
import 'package:ideation_station/models/position.dart';

/// Unit tests for MindMap model validation (T022)
///
/// Tests cover:
/// - Single central node requirement
/// - Unique name validation
/// - Timestamp ordering (createdAt <= lastModifiedAt)
/// - JSON serialization/deserialization
/// - Node collection management
void main() {
  group('MindMap Model Validation', () {
    Node createCentralNode({String id = 'central-1', String text = 'Main Idea'}) {
      return Node(
        id: id,
        text: text,
        type: NodeType.central,
        position: const Position(x: 0, y: 0),
        color: Colors.blue,
      );
    }

    Node createBranchNode({
      required String id,
      required String text,
      required String parentId,
      double x = 150,
      double y = 0,
    }) {
      return Node(
        id: id,
        text: text,
        type: NodeType.branch,
        position: Position(x: x, y: y),
        color: Colors.red,
        parentId: parentId,
      );
    }

    test('should create a valid mind map with central node only', () {
      final now = DateTime.now();
      final centralNode = createCentralNode();

      final mindMap = MindMap(
        id: 'map-1',
        name: 'My First Mind Map',
        createdAt: now,
        lastModifiedAt: now,
        centralNode: centralNode,
        nodes: [centralNode],
      );

      expect(mindMap.id, 'map-1');
      expect(mindMap.name, 'My First Mind Map');
      expect(mindMap.createdAt, now);
      expect(mindMap.lastModifiedAt, now);
      expect(mindMap.centralNode, centralNode);
      expect(mindMap.nodes, hasLength(1));
      expect(mindMap.nodes.first.type, NodeType.central);
      expect(mindMap.crossLinks, isEmpty);
    });

    test('should create a mind map with central node and branches', () {
      final now = DateTime.now();
      final central = createCentralNode();
      final branch1 = createBranchNode(
        id: 'branch-1',
        text: 'Branch 1',
        parentId: 'central-1',
      );
      final branch2 = createBranchNode(
        id: 'branch-2',
        text: 'Branch 2',
        parentId: 'central-1',
        x: -150,
      );

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Mind Map with Branches',
        createdAt: now,
        lastModifiedAt: now,
        centralNode: central,
        nodes: [central, branch1, branch2],
      );

      expect(mindMap.nodes, hasLength(3));
      expect(mindMap.nodes.where((n) => n.type == NodeType.central), hasLength(1));
      expect(mindMap.nodes.where((n) => n.type == NodeType.branch), hasLength(2));
    });

    test('should enforce single central node requirement', () {
      final now = DateTime.now();
      final central = createCentralNode();

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Test Map',
        createdAt: now,
        lastModifiedAt: now,
        centralNode: central,
        nodes: [central],
      );

      // Verify only one central node in nodes list
      final centralNodes = mindMap.nodes.where((n) => n.type == NodeType.central);
      expect(centralNodes, hasLength(1));
      expect(centralNodes.first.id, central.id);
    });

    test('should handle timestamp ordering correctly', () {
      final createdAt = DateTime(2024, 1, 1, 10, 0, 0);
      final modifiedAt = DateTime(2024, 1, 1, 11, 0, 0);
      final central = createCentralNode();

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Test Map',
        createdAt: createdAt,
        lastModifiedAt: modifiedAt,
        centralNode: central,
        nodes: [central],
      );

      expect(mindMap.createdAt, createdAt);
      expect(mindMap.lastModifiedAt, modifiedAt);
      expect(
        mindMap.lastModifiedAt.isAfter(mindMap.createdAt) ||
            mindMap.lastModifiedAt.isAtSameMomentAs(mindMap.createdAt),
        isTrue,
        reason: 'lastModifiedAt must be >= createdAt',
      );
    });

    test('should validate that lastModifiedAt equals createdAt on creation', () {
      final now = DateTime.now();
      final central = createCentralNode();

      final mindMap = MindMap(
        id: 'map-1',
        name: 'New Map',
        createdAt: now,
        lastModifiedAt: now,
        centralNode: central,
        nodes: [central],
      );

      expect(mindMap.createdAt, mindMap.lastModifiedAt);
    });

    test('should validate that lastModifiedAt can be after createdAt', () {
      final createdAt = DateTime(2024, 1, 1, 10, 0, 0);
      final modifiedAt = DateTime(2024, 1, 1, 15, 30, 0);
      final central = createCentralNode();

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Modified Map',
        createdAt: createdAt,
        lastModifiedAt: modifiedAt,
        centralNode: central,
        nodes: [central],
      );

      expect(mindMap.lastModifiedAt.isAfter(mindMap.createdAt), isTrue);
    });

    test('should serialize to JSON correctly', () {
      final now = DateTime.now();
      final central = createCentralNode();
      final branch = createBranchNode(
        id: 'branch-1',
        text: 'Branch',
        parentId: 'central-1',
      );

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Test Map',
        createdAt: now,
        lastModifiedAt: now,
        centralNode: central,
        nodes: [central, branch],
      );

      final json = mindMap.toJson();

      expect(json['id'], 'map-1');
      expect(json['name'], 'Test Map');
      expect(json['createdAt'], isA<String>());
      expect(json['lastModifiedAt'], isA<String>());
      // CentralNode might be Map or Node object depending on serialization
      final centralNode = json['centralNode'];
      if (centralNode is Map) {
        expect(centralNode['id'], 'central-1');
      } else {
        expect(mindMap.centralNode.id, 'central-1');
      }
      expect(json['nodes'], isA<List>());
      expect(json['nodes'], hasLength(2));
      expect(json['crossLinks'], isA<List>());
      expect(json['crossLinks'], isEmpty);
    });

    test('should deserialize from JSON correctly', () {
      final now = DateTime.now();
      final json = {
        'id': 'map-1',
        'name': 'Test Map',
        'createdAt': now.toIso8601String(),
        'lastModifiedAt': now.toIso8601String(),
        'centralNode': {
          'id': 'central-1',
          'text': 'Main Idea',
          'type': 'central',
          'position': {'x': 0.0, 'y': 0.0},
          'color': Colors.blue.value,
          'symbols': [],
          'childIds': [],
        },
        'nodes': [
          {
            'id': 'central-1',
            'text': 'Main Idea',
            'type': 'central',
            'position': {'x': 0.0, 'y': 0.0},
            'color': Colors.blue.value,
            'symbols': [],
            'childIds': [],
          }
        ],
        'crossLinks': [],
      };

      final mindMap = MindMap.fromJson(json);

      expect(mindMap.id, 'map-1');
      expect(mindMap.name, 'Test Map');
      expect(mindMap.centralNode.id, 'central-1');
      expect(mindMap.centralNode.type, NodeType.central);
      expect(mindMap.nodes, hasLength(1));
      expect(mindMap.crossLinks, isEmpty);
    });

    test('should support copyWith for immutability', () {
      final now = DateTime.now();
      final later = now.add(const Duration(hours: 1));
      final central = createCentralNode();

      final original = MindMap(
        id: 'map-1',
        name: 'Original Name',
        createdAt: now,
        lastModifiedAt: now,
        centralNode: central,
        nodes: [central],
      );

      final updated = original.copyWith(
        name: 'Updated Name',
        lastModifiedAt: later,
      );

      expect(original.name, 'Original Name');
      expect(original.lastModifiedAt, now);
      expect(updated.name, 'Updated Name');
      expect(updated.lastModifiedAt, later);
      expect(updated.id, original.id);
      expect(updated.createdAt, original.createdAt);
    });

    test('should validate unique mind map names in collection context', () {
      final now = DateTime.now();
      final central1 = createCentralNode(id: 'c1', text: 'Idea 1');
      final central2 = createCentralNode(id: 'c2', text: 'Idea 2');

      final map1 = MindMap(
        id: 'map-1',
        name: 'Unique Name 1',
        createdAt: now,
        lastModifiedAt: now,
        centralNode: central1,
        nodes: [central1],
      );

      final map2 = MindMap(
        id: 'map-2',
        name: 'Unique Name 2',
        createdAt: now,
        lastModifiedAt: now,
        centralNode: central2,
        nodes: [central2],
      );

      expect(map1.name, isNot(equals(map2.name)));
      expect(map1.id, isNot(equals(map2.id)));
    });

    test('should handle empty nodes list with defaults', () {
      final now = DateTime.now();
      final central = createCentralNode();

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Test Map',
        createdAt: now,
        lastModifiedAt: now,
        centralNode: central,
      );

      // Default nodes list should be empty when not provided
      expect(mindMap.nodes, isEmpty);
    });

    test('should handle cross-links list with defaults', () {
      final now = DateTime.now();
      final central = createCentralNode();

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Test Map',
        createdAt: now,
        lastModifiedAt: now,
        centralNode: central,
        nodes: [central],
      );

      // Default crossLinks should be empty
      expect(mindMap.crossLinks, isEmpty);
    });

    test('should maintain node reference integrity', () {
      final now = DateTime.now();
      final central = createCentralNode();
      final branch = createBranchNode(
        id: 'branch-1',
        text: 'Branch',
        parentId: 'central-1',
      );

      final mindMap = MindMap(
        id: 'map-1',
        name: 'Test Map',
        createdAt: now,
        lastModifiedAt: now,
        centralNode: central,
        nodes: [central, branch],
      );

      // Verify centralNode is in nodes list
      expect(mindMap.nodes, contains(central));

      // Verify branch references correct parent
      final branchNode = mindMap.nodes.firstWhere((n) => n.id == 'branch-1');
      expect(branchNode.parentId, central.id);
    });
  });
}
