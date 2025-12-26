# Quickstart Guide: Mobile Mind Mapping Application

**Feature**: 001-mind-map-mvp
**Audience**: Developers implementing the mind mapping MVP
**Purpose**: Practical guide for development setup and implementation workflow

## Development Environment Setup

### Prerequisites

- Flutter SDK 3.16+ ([flutter.dev](https://flutter.dev))
- Dart 3.2+
- iOS: Xcode 15+ (for iOS development)
- Android: Android Studio with Android SDK 26+ (for Android development)
- Git (version control)

### Project Initialization

```bash
# Create new Flutter project
flutter create ideation_station
cd ideation_station

# Verify Flutter installation
flutter doctor

# Run on device/simulator
flutter run

# Run tests
flutter test
```

### Recommended IDE Setup

- **VS Code**: Flutter extension + Dart extension
- **Android Studio**: Flutter plugin + Dart plugin
- Enable Dart DevTools for performance profiling

## Project Structure Overview

```
lib/
├── main.dart                 # App entry, MaterialApp setup
├── models/                   # Domain entities (immutable data classes)
├── services/                 # Business logic (storage, layout, gestures)
├── ui/
│   ├── screens/             # Full-page screens
│   ├── widgets/             # Reusable UI components
│   └── painters/            # Custom canvas painters
└── utils/                    # Constants, validators, helpers

test/
├── widget/                   # Widget tests (UI components)
├── integration/              # Integration tests (user journeys)
├── unit/                     # Unit tests (business logic)
└── performance/              # Performance benchmarks
```

## TDD Workflow (Critical - Constitution Principle III)

### Step 1: Write Failing Test

```dart
// test/widget/node_widget_test.dart
testWidgets('NodeWidget displays text and color', (tester) async {
  final node = Node(
    id: '1',
    text: 'Test Node',
    color: Colors.blue,
    position: Position(x: 0, y: 0),
  );

  await tester.pumpWidget(MaterialApp(
    home: Scaffold(body: NodeWidget(node: node)),
  ));

  expect(find.text('Test Node'), findsOneWidget);
  // Verify color rendering
  final container = tester.widget<Container>(find.byType(Container));
  expect(container.decoration.color, Colors.blue);
});
```

**Run**: `flutter test test/widget/node_widget_test.dart`
**Expected**: ❌ Test fails (NodeWidget doesn't exist yet)

### Step 2: Implement Minimal Code

```dart
// lib/ui/widgets/node_widget.dart
class NodeWidget extends StatelessWidget {
  final Node node;

  const NodeWidget({required this.node});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: node.color,
        shape: BoxShape.circle,
      ),
      child: Text(node.text),
    );
  }
}
```

**Run**: `flutter test test/widget/node_widget_test.dart`
**Expected**: ✅ Test passes

### Step 3: Refactor

Improve code quality without changing behavior:
- Extract magic numbers to constants
- Add documentation comments
- Improve naming clarity

### Repeat for Each Feature

Follow Red-Green-Refactor cycle for:
- Each user story acceptance scenario
- Each functional requirement
- Each edge case

## Core Implementation Workflow

### Priority Order (User Stories)

1. **P1: Rapid Idea Capture**
   - Central node creation
   - Branch node addition
   - Radial auto-positioning
   - Touch response <100ms

2. **P2: Visual Organization**
   - Color picker
   - Drag-to-reposition
   - Pinch-to-zoom
   - Pan gestures

3. **P3: Complex Ideation**
   - Cross-link creation
   - Symbol palette
   - Link labeling

4. **P4: Save & Retrieve**
   - Local JSON persistence
   - Mind map list
   - Auto-save

### Recommended Implementation Sequence

**Week 1: Data Layer**
```bash
# Implement models
lib/models/mind_map.dart
lib/models/node.dart
lib/models/cross_link.dart
lib/models/symbol.dart

# Implement storage service
lib/services/storage_service.dart

# Write unit tests
test/unit/models/
test/unit/services/storage_service_test.dart
```

**Week 2: Layout & Canvas**
```bash
# Implement layout service
lib/services/layout_service.dart

# Implement canvas
lib/ui/widgets/canvas_widget.dart
lib/ui/painters/connection_painter.dart

# Widget tests
test/widget/canvas_widget_test.dart
```

**Week 3: User Interactions**
```bash
# Implement node widget
lib/ui/widgets/node_widget.dart

# Gesture handling
lib/services/gesture_service.dart

# Touch responsiveness
# Performance profiling
test/performance/canvas_render_test.dart
```

**Week 4: Polish & Integration**
```bash
# Color picker
lib/ui/widgets/color_picker.dart

# Symbol palette
lib/ui/widgets/symbol_palette.dart

# Screens
lib/ui/screens/home_screen.dart
lib/ui/screens/canvas_screen.dart

# E2E tests
test/integration/rapid_idea_capture_test.dart
```

## Performance Profiling

### Enable Performance Overlay

```dart
// lib/main.dart
MaterialApp(
  showPerformanceOverlay: true,  // Shows FPS graph
  ...
)
```

### Profile Mode Testing

```bash
# Run in profile mode (optimized but with profiling enabled)
flutter run --profile

# Check for dropped frames (must maintain 60 fps)
flutter attach --profile
# Open DevTools → Performance
```

### Performance Benchmarks

```dart
// test/performance/canvas_render_test.dart
void main() {
  testWidgets('Canvas renders 100 nodes at 60fps', (tester) async {
    final mindMap = generateMindMapWithNodes(100);

    await tester.pumpWidget(MaterialApp(
      home: CanvasScreen(mindMap: mindMap),
    ));

    // Measure frame rendering time
    final stopwatch = Stopwatch()..start();
    await tester.pump();
    stopwatch.stop();

    expect(stopwatch.elapsedMilliseconds, lessThan(16)); // 60fps = 16ms budget
  });
}
```

## Common Development Tasks

### Adding a New Node Type

1. Update `NodeType` enum in `lib/models/node.dart`
2. Write test for new type rendering
3. Implement rendering logic
4. Update layout service if positioning differs
5. Verify serialization works (save/load test)

### Adding a New Gesture

1. Write integration test for gesture behavior
2. Update `GestureService` with gesture detector
3. Handle gesture in `CanvasWidget`
4. Verify performance (no dropped frames)

### Adding a New Symbol

1. Add to `SymbolType` enum
2. Create SVG/icon asset
3. Update symbol palette widget
4. Test rendering on nodes

## Debugging Tips

### Canvas Not Rendering

- Check `CustomPaint` is receiving correct size
- Verify painter's `paint()` method is called
- Use `debugPrint()` in painter to log coordinates

### Gestures Not Responding

- Ensure `GestureDetector` is above `CustomPaint` in widget tree
- Check for overlapping gesture detectors (may conflict)
- Verify hit-test behavior with `debugPaintPointersEnabled = true`

### Performance Issues

- Profile in profile mode, not debug mode
- Check for unnecessary rebuilds (use `const` widgets)
- Verify custom painters implement `shouldRepaint()` correctly
- Consider using `RepaintBoundary` for static content

### State Not Updating

- Verify state management approach (Provider, setState, etc.)
- Check if `notifyListeners()` is called after state change
- Use Flutter Inspector to view widget tree and state

## Integration Testing

### User Journey Test Example

```dart
// test/integration/rapid_idea_capture_test.dart
testWidgets('User can create mind map with 5 branches in <30s', (tester) async {
  await tester.pumpWidget(MyApp());

  // Create new mind map
  await tester.tap(find.text('New Mind Map'));
  await tester.pumpAndSettle();

  // Enter central idea
  await tester.enterText(find.byType(TextField), 'Central Idea');
  await tester.tap(find.text('Create'));
  await tester.pumpAndSettle();

  // Add 5 branches (simulate rapid creation)
  for (int i = 1; i <= 5; i++) {
    await tester.tap(find.byIcon(Icons.add));
    await tester.enterText(find.byType(TextField), 'Branch $i');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
  }

  // Verify all nodes visible
  expect(find.text('Central Idea'), findsOneWidget);
  for (int i = 1; i <= 5; i++) {
    expect(find.text('Branch $i'), findsOneWidget);
  }
});
```

## Deployment Preparation

### iOS Build

```bash
# Build for iOS (requires Xcode)
flutter build ios --release

# Run on iOS simulator
flutter run -d iphone

# Create IPA for App Store
flutter build ipa
```

### Android Build

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Run on Android emulator
flutter run -d emulator-5554
```

## Next Steps After MVP

Once all P1-P4 user stories are complete and tested:

1. **User Testing**: Deploy to TestFlight (iOS) / Internal Testing (Android)
2. **Gather Metrics**: Track success criteria (SC-001 through SC-015)
3. **Iterate**: Based on user feedback, prioritize post-MVP features
4. **Performance Optimization**: Profile with real user data

## Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Custom Painting in Flutter](https://docs.flutter.dev/cookbook/animation/painter)
- [Testing Flutter Apps](https://docs.flutter.dev/testing)

## Getting Help

- Constitution violations? Review `.specify/memory/constitution.md`
- Architectural questions? Refer to `plan.md` and `data-model.md`
- Interface contracts? Check `contracts/` directory
- Performance issues? See performance budgets in spec.md (FR-027 through FR-032)

---

**Remember**: Follow TDD workflow strictly (Red-Green-Refactor). Tests written first, implementation second. 80%+ coverage for critical user journeys is mandatory per constitution.
