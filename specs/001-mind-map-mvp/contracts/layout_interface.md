# Layout Service Contract

**Feature**: 001-mind-map-mvp
**Purpose**: Define the interface for radial node positioning and spatial algorithms

## Interface Definition

### LayoutService

Abstract interface for calculating node positions in radial mind map layout.

```dart
abstract class LayoutService {
  /// Calculates initial positions for newly created nodes
  /// Returns Position with x,y coordinates in canvas space
  Position calculateInitialPosition({
    required Node parentNode,
    required List<Node> existingSiblings,
    required NodeType nodeType,
  });

  /// Detects collisions between nodes
  /// Returns true if nodes overlap (within collision threshold)
  bool detectCollision(Node nodeA, Node nodeB);

  /// Suggests nudge offset to resolve overlap
  /// Returns Position offset to move nodeB away from nodeA
  Position suggestNudgeOffset(Node nodeA, Node nodeB);

  /// Validates if manual position preserves spatial memory
  /// Returns true if position is acceptable (not too far from original)
  bool validateManualPosition({
    required Position newPosition,
    required Position originalPosition,
    required double maxDistanceThreshold,
  });

  /// Calculates optimal angle for new branch from central node
  /// Distributes branches evenly around circle (0-360 degrees)
  double calculateBranchAngle({
    required int branchIndex,
    required int totalBranches,
  });

  /// Converts polar coordinates (angle, distance) to Cartesian (x, y)
  Position polarToCartesian({
    required double angleDegrees,
    required double distance,
  });
}
```

## Algorithm Specifications

### Radial Distribution

**Central Node**: Always positioned at canvas center (0, 0)

**Primary Branches**:
- Arranged in circle around central node
- Radius: 150dp from center (configurable constant)
- Angle: Evenly distributed (360° / branchCount)
- First branch at 0° (right), subsequent branches clockwise

Example for 4 branches:
- Branch 1: 0° (right) → (150, 0)
- Branch 2: 90° (down) → (0, 150)
- Branch 3: 180° (left) → (-150, 0)
- Branch 4: 270° (up) → (0, -150)

**Sub-Branches**:
- Extend from parent branch at consistent offset
- Distance: 120dp from parent (slightly less than branch-to-center)
- Angle: Inherit parent's general direction ± spread offset
- Spread offset: ±30° from parent angle to create tree-like expansion

### Collision Detection

**Bounding Box Approach**:
- Each node has circular collision radius (based on text length + padding)
- Minimum radius: 40dp (single character)
- Maximum radius: 80dp (long phrase)
- Collision threshold: radiusA + radiusB + 10dp (margin)

**Distance Calculation**:
```dart
double distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
bool collides = distance < (radiusA + radiusB + margin);
```

### Nudge Resolution

When collision detected after manual drag:
1. Calculate vector from nodeA center to nodeB center
2. Normalize vector
3. Extend to minimum safe distance (radiusA + radiusB + margin)
4. Return offset as suggestion (don't auto-apply, show visual feedback)

## Constants & Configuration

```dart
class LayoutConstants {
  // Distance from central node to primary branches
  static const double branchRadius = 150.0;

  // Distance from branch to sub-branch
  static const double subBranchOffset = 120.0;

  // Angle spread for sub-branches
  static const double subBranchSpreadAngle = 30.0;

  // Minimum collision radius
  static const double minNodeRadius = 40.0;

  // Maximum collision radius
  static const double maxNodeRadius = 80.0;

  // Collision margin (whitespace between nodes)
  static const double collisionMargin = 10.0;

  // Maximum distance for "acceptable" manual positioning
  // (preserves spatial memory - warns if dragged >500dp)
  static const double maxManualDragDistance = 500.0;
}
```

## Performance Requirements

- `calculateInitialPosition()`: MUST complete in <5ms
- `detectCollision()`: MUST complete in <1ms (called frequently during drag)
- `suggestNudgeOffset()`: MUST complete in <2ms
- Batch collision detection for 100 nodes: MUST complete in <50ms

## Edge Cases

### Too Many Branches

If >20 branches from central node:
- Continue radial distribution (angles become tighter)
- Consider increasing branchRadius slightly (e.g., +10dp per 10 branches)
- Warn user if >50 branches (usability issue, not technical limit)

### Deep Hierarchies

If sub-branch depth >5 levels:
- Continue tree expansion using consistent offset
- Each level moves further from center
- No special handling required (visual clarity may degrade naturally)

### Overlapping After Manual Drag

- Detect collision in real-time during drag
- Show visual indicator (red outline or gentle vibration)
- Allow user to complete drag anyway (preserve agency)
- Offer "auto-arrange siblings" action to resolve

## Testing Contract

### Unit Tests Required

- Radial distribution with varying branch counts (1, 2, 4, 8, 20)
- Polar to Cartesian conversion accuracy
- Collision detection true positives and negatives
- Nudge offset direction correctness
- Sub-branch angle inheritance

### Integration Tests Required

- Large mind map (100 nodes) layout performance
- Manual drag collision detection responsiveness
- Spatial memory validation for various drag distances

## Usage Examples

### Initial Branch Positioning

```dart
final layoutService = LayoutService.instance;

// Adding 3rd branch to central node (already has 2)
final position = layoutService.calculateInitialPosition(
  parentNode: centralNode,
  existingSiblings: [branch1, branch2],
  nodeType: NodeType.BRANCH,
);
// position.x ≈ -75, position.y ≈ 130 (120° from center)
```

### Collision Detection During Drag

```dart
void onNodeDragged(Node draggedNode, Position newPosition) {
  final collisions = allNodes.where((other) {
    return other.id != draggedNode.id &&
           layoutService.detectCollision(
             draggedNode.copyWith(position: newPosition),
             other,
           );
  }).toList();

  if (collisions.isNotEmpty) {
    showCollisionIndicator();
  }
}
```

### Sub-Branch Positioning

```dart
// Adding child to branch at 0° (right side)
final parentAngle = atan2(parentNode.position.y, parentNode.position.x);
final childAngle = parentAngle + 0.2; // Slight clockwise offset

final childPosition = layoutService.polarToCartesian(
  angleDegrees: childAngle * 180 / pi,
  distance: LayoutConstants.branchRadius + LayoutConstants.subBranchOffset,
);
```

## Implementation Notes

- Use `dart:math` for trigonometric functions
- Cache calculated positions to avoid redundant computation
- Consider using spatial indexing (quadtree) for collision detection if >200 nodes
- Radial layout MUST privilege visual balance over compactness
- Never auto-move existing nodes to resolve collisions (violates spatial memory principle)
