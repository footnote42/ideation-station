# Technical Research: Mobile Mind Mapping Application

**Feature**: 001-mind-map-mvp
**Date**: 2025-12-26
**Purpose**: Resolve technical unknowns and select optimal dependencies for Flutter implementation

## Research Summary

This document captures key technical decisions for building a high-performance mind mapping application in Flutter. All decisions prioritize simplicity, performance (60fps, <100ms response), and constitution compliance.

---

## 1. Canvas Rendering Strategy

### Decision

**CustomPaint + InteractiveViewer** (both built-in Flutter)

### Rationale

1. **Performance**: CustomPaint integrates directly with Flutter's rendering pipeline, easily achieving 60fps with 100+ nodes when properly implemented
2. **Control**: Full control over radial layout algorithm specific to mind mapping methodology
3. **Zero External Dependencies**: Aligns with "Simplicity First" constitution principle
4. **Gesture Support**: InteractiveViewer provides production-ready pan/zoom with minimal code
5. **Spatial Memory**: Complete control over coordinate system preserves exact node positions

### Implementation Approach

```dart
InteractiveViewer(
  boundaryMargin: EdgeInsets.all(double.infinity), // Infinite canvas
  minScale: 0.5,
  maxScale: 2.0,
  constrained: false,
  child: CustomPaint(
    painter: ConnectionPainter(connections),
    child: Stack(
      children: nodes.map((node) =>
        Positioned(
          left: node.x,
          top: node.y,
          child: RepaintBoundary(child: NodeWidget(node)),
        )
      ).toList(),
    ),
  ),
)
```

### Performance Optimizations

- Use `RepaintBoundary` to isolate node repaints
- Implement efficient `shouldRepaint()` in CustomPainter
- Cache Paint objects to avoid recreation per frame
- Use `Canvas.drawLine()` for connections (faster than Path)
- Optional viewport culling for very large maps (>200 nodes)

### Alternatives Considered

| Option | Why Rejected |
|--------|--------------|
| **flame** (game engine) | Overkill, adds 500KB+ to app size, steep learning curve |
| **flutter_canvas** | Abandoned/unmaintained, not production-ready |
| **graphic** | Focused on data visualization, not interactive node graphs |
| **Full CustomPaint for nodes** | Harder to handle text input and accessibility |

---

## 2. State Management

### Decision

**Riverpod 2.x** (`flutter_riverpod: ^2.5.0`)

### Rationale

1. **Performance**: Fine-grained reactivity means only affected widgets rebuild (critical for 60fps with 100+ nodes)
2. **Simplicity**: Cleaner syntax than Bloc, less boilerplate than Provider 6.x
3. **Testability**: Providers are easily mockable and overridable
4. **Undo/Redo Support**: Natural fit with StateNotifier pattern for command history
5. **Auto-save Triggers**: Built-in `ref.listen()` makes debounced saves trivial
6. **No BuildContext Required**: Access state from anywhere (useful for gesture handlers)
7. **Compile-time Safety**: Strong typing catches errors at compile time

### Key Implementation Patterns

**State Notifier for Mind Map**:
```dart
final mindMapProvider = StateNotifierProvider<MindMapNotifier, MindMap?>((ref) {
  return MindMapNotifier(ref.watch(storageServiceProvider));
});

class MindMapNotifier extends StateNotifier<MindMap?> {
  final StorageService _storage;
  final List<MindMap> _history = []; // Undo/redo history
  int _historyIndex = -1;

  void addNode(Node node) {
    if (state == null) return;
    _saveToHistory();
    state = state!.copyWith(
      nodes: [...state!.nodes, node],
      lastModified: DateTime.now(),
    );
  }

  void undo() {
    if (_historyIndex > 0) {
      _historyIndex--;
      state = _history[_historyIndex];
    }
  }
}
```

**Auto-save with Debouncing**:
```dart
ref.listen(mindMapProvider, (previous, next) {
  if (next != null) {
    _debouncedSave(ref.read(storageServiceProvider), next);
  }
});

Timer? _saveTimer;
void _debouncedSave(StorageService storage, MindMap map) {
  _saveTimer?.cancel();
  _saveTimer = Timer(Duration(milliseconds: 500), () {
    storage.saveMindMap(map);
  });
}
```

### Alternatives Considered

| Option | Why Rejected |
|--------|--------------|
| **Bloc** | Excellent but overkill - requires Events, States, Blocs for every feature (3x code). Undo/redo would add even more boilerplate |
| **GetX** | Fast but criticized for anti-patterns, magic globals, potential spaghetti code. Violates "Simplicity First" principle |
| **Provider** | Good but more verbose than Riverpod, harder dependency graphs. Riverpod is "Provider done right" by same author |
| **setState()** | Too basic - entire canvas would rebuild on every node change, violating 60fps requirement |

---

## 3. Local Storage & Serialization

### Decision

**JSON Files + Freezed + JSON Serializable**

**Packages**:
- `path_provider: ^2.1.0` (file system access)
- `freezed: ^2.4.0` (immutable models)
- `json_serializable: ^6.7.0` (type-safe serialization)

### Rationale

1. **Simplicity**: Direct file I/O is faster than SQLite for document-style data
2. **Type Safety**: Code generation prevents runtime serialization errors
3. **Immutability**: Freezed provides copyWith, equality, and JSON serialization with minimal boilerplate
4. **Debuggability**: Human-readable JSON files easy to inspect and debug
5. **No Schema Migrations**: Each mind map is self-contained document
6. **Performance**: 50-100KB JSON files serialize in <100ms

### File System Structure

```
<app_documents_directory>/mindmaps/
├── index.json                    # Metadata (names, timestamps)
├── <uuid-1>.json                 # Mind map 1
├── <uuid-2>.json                 # Mind map 2
└── backups/
    └── <uuid-1>_<timestamp>.json # Backup before delete
```

### Implementation Pattern

```dart
// Model with freezed
@freezed
class Node with _$Node {
  const factory Node({
    required String id,
    required String text,
    @OffsetConverter() required Offset position,
    @ColorConverter() required Color color,
    String? parentId,
    @Default([]) List<String> symbolIds,
  }) = _Node;

  factory Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);
}

// Storage service
class StorageService {
  Future<void> saveMindMap(MindMap map) async {
    final file = await _getMindMapFile(map.id);
    final tempFile = File('${file.path}.tmp');

    // Atomic write: temp file → rename
    final json = jsonEncode(map.toJson());
    await tempFile.writeAsString(json);
    await tempFile.rename(file.path); // Atomic on most filesystems
  }
}
```

### Performance Considerations

- Lazy load mind map list (index.json only, full maps on demand)
- Incremental saves (only changed mind map, not entire index)
- Background isolate for serialization if map >1000 nodes
- Optional gzip compression for maps >1MB (post-MVP)

### Alternatives Considered

| Option | Why Rejected |
|--------|--------------|
| **sqflite** | Overkill - requires schema management, migrations, queries. Mind maps are documents, not relational data |
| **hive** | Binary format harder to debug, no human-readable backups |
| **shared_preferences** | Limited to 8MB total on Android, not designed for large documents |
| **Manual JSON** | Error-prone, no type safety, would violate TDD principle |

---

## 4. Testing Infrastructure

### Decision

**Standard Flutter Testing Stack**

**Packages**:
```yaml
dev_dependencies:
  flutter_test: sdk            # Widget & unit tests
  integration_test: sdk        # E2E tests
  golden_toolkit: ^0.15.0      # Visual regression tests
  mockito: ^5.4.0              # Mocking
```

### Test Strategy

**Coverage Targets**:
- Widget tests: 60% of coverage
- Integration tests: 30% of coverage
- Performance tests: 10% of coverage
- **Total**: 80%+ coverage (constitution requirement)

**Test Organization**:
```
test/
  widget/           # UI component tests
  integration/      # User journey tests (P1-P4 stories)
  unit/             # Business logic tests
  performance/      # 60fps validation, latency benchmarks
  goldens/          # Visual regression tests
```

### Key Test Patterns

**Widget Test Example** (Touch Response <100ms):
```dart
testWidgets('Node responds to tap within 100ms', (tester) async {
  bool tapped = false;

  await tester.pumpWidget(
    MaterialApp(home: NodeWidget(node: node, onTap: () => tapped = true)),
  );

  final stopwatch = Stopwatch()..start();
  await tester.tap(find.byType(NodeWidget));
  await tester.pump();
  stopwatch.stop();

  expect(tapped, isTrue);
  expect(stopwatch.elapsedMilliseconds, lessThan(100));
});
```

**Performance Test Example** (60fps with 100 nodes):
```dart
testWidgets('Canvas maintains 60fps with 100 nodes', (tester) async {
  final nodes = List.generate(100, (i) => Node(...));

  await tester.pumpWidget(
    MaterialApp(home: CanvasScreen(mindMap: mindMap)),
  );

  final timeline = await tester.binding.traceAction(() async {
    await tester.drag(find.byType(InteractiveViewer), Offset(100, 100));
    await tester.pumpAndSettle();
  });

  final avgFrameTime = /* calculate from timeline */;
  expect(avgFrameTime.inMilliseconds, lessThan(17)); // 60fps = 16.67ms
});
```

**Integration Test Example** (User Story P1):
```dart
testWidgets('User can create central node + 5 branches in <30s', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // Create new mind map
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();

  // Enter central idea
  await tester.enterText(find.byType(TextField), 'Central Idea');
  await tester.testTextInput.receiveAction(TextInputAction.done);

  // Add 5 branches
  for (int i = 1; i <= 5; i++) {
    await tester.tap(find.byIcon(Icons.add_circle));
    await tester.enterText(find.byType(TextField).last, 'Branch $i');
    await tester.testTextInput.receiveAction(TextInputAction.done);
  }

  // Verify all visible
  expect(find.text('Central Idea'), findsOneWidget);
  for (int i = 1; i <= 5; i++) {
    expect(find.text('Branch $i'), findsOneWidget);
  }
});
```

### CI/CD Integration

```yaml
# .github/workflows/test.yml
- run: flutter test --coverage
- run: flutter test integration_test
- name: Check coverage threshold
  run: |
    lcov --summary coverage/lcov.info | grep "lines" | awk '{print $2}' | sed 's/%//' | awk '{if ($1 < 80) exit 1}'
```

### Alternatives Considered

| Option | Why Rejected |
|--------|--------------|
| **patrol** | Newer framework, less mature than integration_test |
| **alchemist** | Golden testing alternative, but golden_toolkit has better support |
| **flutter_driver** | Deprecated, replaced by integration_test |

---

## 5. Additional Dependencies

### UUID Generation

**Decision**: `uuid: ^4.3.0`

**Rationale**: Most popular UUID package, supports v4 (random), zero dependencies, tiny size (~10KB)

```dart
import 'package:uuid/uuid.dart';

final uuid = Uuid();
final node = Node(id: uuid.v4(), ...);
```

**Alternatives**: Manual implementation (error-prone), nanoid (less standard)

---

### Color Picker

**Decision**: `flex_color_picker: ^3.4.0`

**Rationale**: Most feature-complete color picker, highly customizable, Material 3 support, excellent performance

```dart
import 'package:flex_color_picker/flex_color_picker.dart';

ColorPicker(
  color: currentColor,
  onColorChanged: (Color color) {
    ref.read(mindMapProvider.notifier).updateNodeColor(nodeId, color);
  },
  width: 44,
  height: 44,
  borderRadius: 22,
  pickersEnabled: {ColorPickerType.wheel: true},
)
```

**Alternatives**: flutter_colorpicker (less maintained), custom implementation (2+ days work), flutter_material_color_picker (too limited)

---

## Final Dependency List

### Runtime Dependencies (6 total)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.0       # State management
  path_provider: ^2.1.0           # File system access
  uuid: ^4.3.0                    # Node ID generation
  flex_color_picker: ^3.4.0       # Color selection UI
  freezed_annotation: ^2.4.0      # Immutable models
  json_annotation: ^4.8.0         # JSON serialization
```

### Dev Dependencies (8 total)

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  build_runner: ^2.4.0            # Code generation
  freezed: ^2.4.0                 # Model generation
  json_serializable: ^6.7.0       # JSON generation
  golden_toolkit: ^0.15.0         # Visual regression tests
  mockito: ^5.4.0                 # Test mocking
  flutter_lints: ^3.0.0           # Official linting rules
```

---

## Complexity Budget Assessment

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| **Runtime Dependencies** | <10 | 6 | ✅ Pass |
| **Dev Dependencies** | <15 | 8 | ✅ Pass |
| **App Size** | <50MB | ~45MB estimated | ✅ Pass |
| **Custom Painters** | <5 | 2 (ConnectionPainter, CrossLinkPainter) | ✅ Pass |
| **Total Dart Files** | <50 | ~25-30 estimated | ✅ Pass |

**Complexity Justification**: All dependencies have clear justification and proven track record. No over-engineering detected. Stack prioritizes simplicity and performance per constitution.

---

## Performance Validation Checklist

Before marking MVP complete:

- [ ] Canvas maintains 60fps with 100+ nodes (validated via Flutter DevTools)
- [ ] Touch response <100ms (measured with Stopwatch in tests)
- [ ] Cold start <2 seconds (measured with `flutter run --profile`)
- [ ] Auto-save <500ms without UI jank (timeline tracing)
- [ ] Widget tests achieve 80%+ coverage for critical paths
- [ ] Integration tests cover all P1-P4 user stories end-to-end
- [ ] Golden tests prevent visual regressions

---

## Open Questions Resolved

| Question | Resolution |
|----------|------------|
| Should we use freezed for immutable data classes? | **Yes** - Provides immutability, copyWith, equality, and JSON serialization with minimal boilerplate |
| How to handle large mind maps (>1000 nodes)? | **Out of scope for MVP** - Optimize post-launch based on user feedback. Current architecture supports up to 200 nodes comfortably |
| Custom painters vs third-party canvas library? | **Custom painters** - Built-in Flutter, full control, zero dependencies |
| Which state management approach? | **Riverpod** - Best balance of simplicity, performance, and features |

---

## Implementation Priority

Based on P1-P4 user stories:

1. **Phase 1 (P1 - Rapid Idea Capture)**:
   - Set up Riverpod state management
   - Implement Node and MindMap models with freezed
   - Build basic CustomPaint canvas with InteractiveViewer
   - Create NodeWidget with tap detection (<100ms response)

2. **Phase 2 (P2 - Visual Organization)**:
   - Integrate flex_color_picker
   - Implement drag-to-reposition
   - Add path_provider + JSON storage
   - Build auto-save mechanism (500ms debounce)

3. **Phase 3 (P3 - Complex Ideation)**:
   - Implement CrossLink model
   - Create ConnectionPainter for cross-links
   - Add symbol palette

4. **Phase 4 (P4 - Save & Retrieve)**:
   - Build home screen with mind map list
   - Implement delete functionality
   - Add error handling for corrupted files

---

## Architecture Decision Records (ADRs)

### ADR-001: Why Flutter over React Native

**Decision**: Flutter (already specified in spec.md)

**Rationale**:
- Superior canvas rendering performance (Skia graphics engine)
- Single codebase for iOS/Android
- Better suited for custom graphics (mind mapping requires custom rendering)
- Excellent gesture handling for touch interactions

### ADR-002: Why JSON over SQLite

**Decision**: JSON files via path_provider

**Rationale**:
- Mind maps are self-contained documents, not relational data
- Simpler implementation (no schema, no migrations)
- Easier debugging (human-readable files)
- Faster for document-style reads/writes

### ADR-003: Why Riverpod over Bloc

**Decision**: Riverpod for state management

**Rationale**:
- Less boilerplate than Bloc (simpler = better per constitution)
- Sufficient for single-user app (no complex event sourcing needed)
- Easier undo/redo implementation
- Better performance for frequent state updates (node positioning)

---

## References

- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [CustomPaint Documentation](https://api.flutter.dev/flutter/widgets/CustomPaint-class.html)
- [Riverpod Documentation](https://riverpod.dev)
- [Freezed Package](https://pub.dev/packages/freezed)
- [InteractiveViewer Documentation](https://api.flutter.dev/flutter/widgets/InteractiveViewer-class.html)

---

**Conclusion**: All technical unknowns resolved. Recommended stack prioritizes simplicity, performance, and constitution compliance. Ready to proceed to Phase 1 (Design & Contracts).
