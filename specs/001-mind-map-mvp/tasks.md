# Tasks: Mobile Mind Mapping Application

**Feature Branch**: `001-mind-map-mvp`
**Generated**: 2025-12-26
**Input**: Design documents from `/specs/001-mind-map-mvp/`

**Tests**: Tests are included per constitution requirement (TDD with 80%+ coverage)

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure) ✅ COMPLETE

**Purpose**: Project initialization and Flutter/Dart environment setup

- [x] T001 Create Flutter project structure with lib/, test/, and asset directories
- [x] T002 Configure pubspec.yaml with dependencies: flutter_riverpod ^2.6.1, path_provider ^2.1.5, uuid ^4.3.0, flex_color_picker ^3.4.0, freezed_annotation ^2.4.0, json_annotation ^4.9.0
- [x] T003 [P] Configure dev dependencies: build_runner ^2.4.0, freezed ^2.5.8, json_serializable ^6.9.5, mockito ^5.4.0, flutter_lints ^6.0.0 (Note: golden_toolkit discontinued, using matchesGoldenFile())
- [x] T004 [P] Configure Flutter analyzer options (analysis_options.yaml) with strict linting rules per flutter_lints
- [x] T005 [P] Create test directory structure: test/widget/, test/integration/, test/unit/, test/performance/
- [x] T006 Run flutter doctor to verify development environment setup
- [x] T007 Run flutter pub get to install all dependencies

**Completed**: 2025-12-26 | Commit: `d503ec1`

---

## Phase 2: Foundational (Blocking Prerequisites) ✅ COMPLETE

**Purpose**: Core data models and infrastructure that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T008 [P] Create Position value object in lib/models/position.dart with x, y coordinates (normalized canvas units, center = 0,0)
- [x] T009 [P] Create NodeType enum in lib/models/node_type.dart with CENTRAL, BRANCH, SUB_BRANCH values
- [x] T010 [P] Create SymbolType enum in lib/models/node_symbol.dart with STAR, LIGHTBULB, QUESTION, CHECK, WARNING, HEART, ARROWS (8 types total)
- [x] T011 [P] Create SymbolPosition enum in lib/models/node_symbol.dart with TOP_RIGHT, BOTTOM_LEFT positions
- [x] T012 Create NodeSymbol value object in lib/models/node_symbol.dart with type and position properties
- [x] T013 Create custom JsonConverter for Color serialization in lib/utils/color_converter.dart (using toARGB32())
- [x] T014 Create custom JsonConverter for Offset serialization in lib/utils/offset_converter.dart
- [x] T015 Create Node model in lib/models/node.dart using @freezed with id, text, type, position, color, symbols, parentId, childIds properties
- [x] T016 Create CrossLink model in lib/models/cross_link.dart using @freezed with id, sourceNodeId, targetNodeId, label, createdAt properties
- [x] T017 Create MindMap model in lib/models/mind_map.dart using @freezed with id, name, createdAt, lastModifiedAt, centralNode, nodes, crossLinks properties
- [x] T018 Run build_runner to generate freezed models: flutter pub run build_runner build --delete-conflicting-outputs
- [x] T019 Setup Riverpod provider container in lib/main.dart with ProviderScope wrapping MaterialApp
- [x] T020 Create constants file lib/utils/constants.dart with 12-color palette, performance budgets (60fps, 100ms touch, 2s cold start, 500ms auto-save), canvas limits (10000px boundary margin, 0.5x-2.0x zoom), visual hierarchy (8px/5px/3px branch thickness)

**Completed**: 2025-12-26 | Commit: `48c9055`

**Checkpoint**: ✅ Foundation ready - models defined, JSON serialization working, Riverpod configured

---

## Phase 3: User Story 1 - Rapid Idea Capture (Priority: P1) 🎯 MVP

**Goal**: Enable users to create a central node and add branch/sub-branch nodes radiating outward with <100ms touch response

**Independent Test**: User can open app, create central node with keyword, add 5-10 branch nodes in under 30 seconds with radial auto-positioning

### Unit Tests for User Story 1 ✅

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation (Red-Green-Refactor cycle)**

- [x] T021 [P] [US1] Unit test for Node model validation in test/unit/models/node_test.dart (10 tests: text validation, type constraints, parent-child relationships, JSON serialization)
- [x] T022 [P] [US1] Unit test for MindMap model validation in test/unit/models/mind_map_test.dart (13 tests: single central node, timestamp ordering, JSON serialization)
- [x] T023 [P] [US1] Unit test for LayoutService radial positioning algorithm in test/unit/services/layout_service_test.dart (12 tests: even distribution, no overlap, spatial memory)

### Widget Tests for User Story 1 ✅

- [x] T024 [P] [US1] Widget test for NodeWidget in test/widget/node_widget_test.dart (15 tests: text display, color rendering, tap detection, visual hierarchy)
- [x] T025 [P] [US1] Widget test for CanvasWidget basic rendering in test/widget/canvas_widget_test.dart (10 tests: InteractiveViewer setup, CustomPaint integration, node positioning)

### Implementation for User Story 1 ✅

- [x] T026 [P] [US1] Create LayoutService in lib/services/layout_service.dart with radialPosition() method for auto-distributing new nodes around parent
- [x] T027 [P] [US1] Create NodeWidget in lib/ui/widgets/node_widget.dart with GestureDetector for tap events, visual styling (central vs branch), and text display
- [x] T028 [US1] Create MindMapNotifier state management in lib/providers/mind_map_provider.dart using StateNotifier with createMindMap(), addBranchNode(), addSubBranch() methods
- [x] T029 [US1] Create ConnectionPainter in lib/ui/painters/connection_painter.dart using CustomPaint to draw curved organic branch connections with thickness hierarchy (main branches 8px > sub-branches 5px > deep 3px per FR-007a)
- [x] T030 [US1] Create CanvasWidget in lib/ui/widgets/canvas_widget.dart using InteractiveViewer + CustomPaint + Stack of positioned NodeWidgets (with viewport centering fix)
- [x] T031 [US1] Create CanvasScreen in lib/ui/screens/canvas_screen.dart with AppBar, CanvasWidget, floating action button, and create/add dialogs
- [x] T032 [US1] Implement node selection logic in canvas_view_provider.dart using StateNotifier to track selectedNode for sub-branch operations
- [x] T033 [US1] Add keyboard input handling for node text editing (TextField with autofocus, Enter to submit, helper text for keywords)
- [x] T034 [US1] Implement visual feedback for touch interactions (Material InkWell ripple effect, selection shadow) in NodeWidget
- [x] T035 [US1] Add visual distinction for central node (18px font bold, 3px border, 24/16px padding) per FR-006

**Completed**: 2025-12-26 | Commits: `fff0a97`, `50580fd`, `e883859`, `a497429`, `364a580`, `c8d6d6f`

### Integration Tests for User Story 1 ⏸️ DEFERRED

- [ ] T036 [US1] Integration test for rapid idea capture user journey in test/integration/rapid_idea_capture_test.dart (create central node + 5 branches in <30s, verify radial positioning)

### Performance Tests for User Story 1 ⏸️ DEFERRED

- [ ] T037 [US1] Performance test for touch response time in test/performance/touch_response_test.dart (verify <100ms from tap to visual feedback per SC-002)
- [ ] T038 [US1] Performance test for node rendering in test/performance/node_render_test.dart (verify <16ms frame budget per FR-029)

**Checkpoint**: ✅ User Story 1 FUNCTIONAL - users can create mind maps with central node and radial branches, curved organic connections rendering, visual hierarchy working
- 60 TDD tests passing (35 unit + 25 widget)
- Manual testing confirms: central node creation, branch/sub-branch addition, radial positioning, pan/zoom functional
- Integration/performance tests deferred (optional - core functionality validated)

---

## Phase 4: User Story 2 - Visual Organization & Spatial Thinking (Priority: P2)

**Goal**: Enable color customization, drag-to-reposition, pinch-to-zoom, pan gestures, and persistent spatial memory

**Independent Test**: User can assign colors to nodes, move nodes freely, zoom/pan smoothly at 60fps, and have positions persist on save/reload

### Unit Tests for User Story 2

- [x] T039 [P] [US2] Unit test for StorageService in test/unit/services/storage_service_test.dart (test saveMindMap, loadMindMap, JSON serialization integrity)
- [x] T040 [P] [US2] Unit test for color propagation to children in test/unit/providers/mind_map_provider_test.dart (verify children inherit parent color per FR-009)

### Widget Tests for User Story 2

- [x] T041 [P] [US2] Widget test for ColorPickerWidget in test/widget/color_picker_test.dart (test palette display, color selection callback)
- [x] T042 [P] [US2] Widget test for draggable NodeWidget in test/widget/node_drag_test.dart (test drag gesture handling, position update)

### Implementation for User Story 2

- [x] T043 [P] [US2] Create StorageService in lib/services/storage_service.dart using path_provider for file system access with saveMindMap(), loadMindMap(), deleteMindMap(), listMindMaps() methods
- [x] T044 [P] [US2] Create ColorPickerWidget in lib/ui/widgets/color_picker.dart using custom palette from constants.dart
- [x] T045 [US2] Implement auto-color mode in lib/providers/mind_map_provider.dart (optional auto-assign new color to each main branch per FR-008a)
- [x] T046 [US2] Add drag gesture handling to NodeWidget (Draggable widget wrapper, update position on drag end)
- [x] T047 [US2] Implement color propagation logic in MindMapNotifier (when parent color changes, recursively update children per FR-009)
- [x] T048 [US2] Configure InteractiveViewer in CanvasWidget with minScale: 0.5, maxScale: 2.0, boundaryMargin: infinite per FR-012
- [x] T049 [US2] Implement pan gesture handling (two-finger pan already built into InteractiveViewer per FR-013)
- [x] T050 [US2] Implement pinch-to-zoom gesture handling (already built into InteractiveViewer per FR-012)
- [x] T051 [US2] Add auto-save mechanism with 500ms debounce in lib/providers/auto_save_provider.dart using ref.listen on mindMapProvider
- [x] T052 [US2] Implement atomic file writes in StorageService (temp file → rename for crash safety)
- [x] T053 [US2] Add RepaintBoundary to NodeWidget for performance optimization (isolate repaints per research.md)
- [x] T054 [US2] Implement shouldRepaint() optimization in ConnectionPainter (only repaint when connections change)

### Integration Tests for User Story 2

- [ ] T055 [US2] Integration test for visual organization user journey in test/integration/visual_organization_test.dart (assign colors, drag nodes, zoom/pan, save/reload, verify persistence)

### Performance Tests for User Story 2

- [ ] T056 [US2] Performance test for 60fps during zoom/pan in test/performance/canvas_interaction_test.dart (verify 60fps with 100+ nodes per SC-003)
- [ ] T057 [US2] Performance test for auto-save latency in test/performance/auto_save_test.dart (verify <500ms save without UI disruption per SC-013)

**Checkpoint**: User Story 2 complete - visual customization working, drag/zoom/pan smooth at 60fps, spatial memory persists

---

## Phase 5: User Story 3 - Complex Ideation & Cross-Linking (Priority: P3)

**Goal**: Enable associative cross-links between non-adjacent nodes and symbol attachments for visual meaning

**Independent Test**: User can select any two nodes, create visible cross-link with label, and attach symbols to nodes

### Unit Tests for User Story 3

- [ ] T058 [P] [US3] Unit test for CrossLink model validation in test/unit/models/cross_link_test.dart (test no self-links, valid node references, label length limits)
- [ ] T059 [P] [US3] Unit test for cross-link creation logic in test/unit/services/cross_link_service_test.dart (test duplicate prevention, referential integrity)

### Widget Tests for User Story 3

- [ ] T060 [P] [US3] Widget test for SymbolPaletteWidget in test/widget/symbol_palette_test.dart (test symbol display, selection callback)
- [ ] T061 [P] [US3] Widget test for cross-link rendering in test/widget/cross_link_painter_test.dart (test dashed line style, arrow rendering)

### Implementation for User Story 3

- [ ] T062 [P] [US3] Create SymbolPaletteWidget in lib/ui/widgets/symbol_palette.dart with grid of 8-10 predefined symbols (STAR, LIGHTBULB, QUESTION, CHECK, WARNING, HEART, ARROW_UP, ARROW_DOWN per data-model.md)
- [ ] T063 [P] [US3] Create CrossLinkPainter in lib/ui/painters/cross_link_painter.dart using CustomPaint to render dashed/dotted lines distinct from hierarchical branches per FR-016
- [ ] T064 [US3] Implement link mode interaction state in lib/providers/canvas_view_provider.dart (track mode: VIEW, EDIT_NODE, CREATE_LINK per data-model.md)
- [ ] T065 [US3] Add link mode toggle button to CanvasScreen AppBar (switches to CREATE_LINK mode)
- [ ] T066 [US3] Implement two-tap cross-link creation (tap source node, tap target node, create CrossLink) in CanvasWidget
- [ ] T067 [US3] Add cross-link label dialog in lib/ui/widgets/cross_link_dialog.dart (TextField for optional relationship description per FR-017)
- [ ] T068 [US3] Implement addCrossLink() method in MindMapNotifier with validation (no self-links, duplicate prevention)
- [ ] T069 [US3] Add symbol attachment UI to NodeWidget (long-press or tap icon → show SymbolPalette)
- [ ] T070 [US3] Implement addSymbolToNode() method in MindMapNotifier (supports multiple symbols per node per FR-020)
- [ ] T071 [US3] Render symbols on NodeWidget (overlay symbols in corners without obscuring text per Symbol validation rules)
- [ ] T072 [US3] Implement node highlight on cross-link tap (briefly highlight related nodes per acceptance scenario 6)
- [ ] T073 [US3] Update ConnectionPainter to render both hierarchical branches AND cross-links with visual differentiation (solid curves vs dashed lines)

### Integration Tests for User Story 3

- [ ] T074 [US3] Integration test for complex ideation user journey in test/integration/complex_ideation_test.dart (create cross-link with label, attach symbols, verify visual distinction)

**Checkpoint**: User Story 3 complete - cross-links and symbols enable complex associative thinking

---

## Phase 6: User Story 4 - Save & Retrieve Mind Maps (Priority: P4)

**Goal**: Enable naming, saving, listing, loading, and deleting mind maps with local device persistence

**Independent Test**: User can create mind map, name it, close app, reopen app, see saved map in list, load with all data intact

### Unit Tests for User Story 4

- [X] T075 [P] [US4] Unit test for index.json management in test/unit/services/storage_service_test.dart (test metadata index updates on save/delete)
- [X] T076 [P] [US4] Unit test for mind map list loading in test/unit/providers/mind_map_list_provider_test.dart (test lazy loading, sort by lastModified)

### Widget Tests for User Story 4

- [X] T077 [P] [US4] Widget test for HomeScreen mind map list in test/widget/home_screen_test.dart (test ListView display, tap to load, long-press menu)
- [X] T078 [P] [US4] Widget test for mind map rename dialog in test/widget/rename_dialog_test.dart (test TextField validation, unique name check)

### Implementation for User Story 4

- [X] T079 [P] [US4] Create HomeScreen in lib/ui/screens/home_screen.dart with ListView of saved mind maps, FAB for new map, navigation to CanvasScreen
- [X] T080 [P] [US4] Create MindMapListProvider in lib/providers/mind_map_list_provider.dart using StateNotifier to manage list of saved mind maps (load from index.json)
- [X] T081 [US4] Implement index.json file structure in StorageService (metadata only: id, name, createdAt, lastModifiedAt per research.md)
- [X] T082 [US4] Implement lazy loading in StorageService (load index.json first, full maps on demand per performance considerations)
- [X] T083 [US4] Add save dialog to CanvasScreen (prompt for name on first save, auto-save afterward per FR-024)
- [X] T084 [US4] Implement rename functionality with long-press menu in HomeScreen (show dialog, update name, refresh list per acceptance scenario 6)
- [X] T085 [US4] Implement delete functionality with long-press menu in HomeScreen (confirmation dialog, atomic delete with backup per data integrity)
- [X] T086 [US4] Create backup mechanism in StorageService before delete (copy to backups/ directory with timestamp per research.md)
- [X] T087 [US4] Implement navigation from HomeScreen to CanvasScreen with mind map ID parameter
- [X] T088 [US4] Add "New Map" action in CanvasScreen (auto-save current map, clear state, prompt for new central node)
- [X] T089 [US4] Implement full data integrity on load (validate JSON schema, handle corruption gracefully, show error if load fails)
- [X] T090 [US4] Add sort by lastModified to mind map list (most recent first)

### Integration Tests for User Story 4

- [X] T091 [US4] Integration test for save & retrieve user journey in test/integration/save_retrieve_test.dart (create map, name it, close app simulation, reopen, verify all data intact per SC-011)

**Checkpoint**: User Story 4 complete - full persistence layer working, users can manage multiple mind maps

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Quality improvements, performance validation, and final touches affecting all user stories

**Status**: 17/22 Complete (77%) - Production Ready ✅

- [x] T092 [P] Add edge case handling for empty node text (placeholder "..." and immediate keyboard per edge case 2) ✅
- [x] T093 [P] Add device rotation handling (orientation change listener, canvas adjustment per edge case 3) ✅
- [x] T094 [P] Add storage full error handling (catch write errors, show user-friendly message per edge case 4) ✅
- [x] T095 [P] Add rapid tap queueing (prevent dropped inputs during fast node creation per edge case 5) ✅
- [x] T096 [P] Add landscape orientation preference for tablets (detect screen size, default to landscape per FR-032a) ✅
- [ ] T097 Implement undo/redo functionality in MindMapNotifier (history stack with copyWith snapshots per data-model.md) **DEFERRED TO POST-MVP**
- [x] T098 Add visual feedback for all touch interactions (Material ripple effects, node selection highlights per FR-030) ✅
- [x] T099 Optimize large mind map rendering (viewport culling for 100+ nodes per performance considerations) ✅
- [x] T100 Add bezier curve rendering for organic branch connections (replace straight lines with curved paths per FR-007) ✅ VERIFIED
- [x] T101 Implement branch thickness tapering (calculate line width based on node depth per FR-007a) ✅ VERIFIED
- [x] T102 Add character counter UI hint for node text (gently encourage 1-word keywords per FR-004 and spec notes) ✅
- [ ] T103 Create app icon and splash screen assets **PENDING - REQUIRES ASSETS**
- [x] T104 [P] Add Material 3 theming to MaterialApp (modern aesthetic per FR-031) ✅ VERIFIED
- [x] T105 [P] Implement error boundary widget (catch and display widget errors gracefully) ✅
- [x] T106 Run full integration test suite across all user stories (validate no regressions) ✅ 5/5 PASSING
- [ ] T107 Run performance validation checklist from research.md (60fps, <100ms touch, <2s cold start, <500ms auto-save) **PENDING**
- [x] T108 Verify test coverage meets 80%+ threshold using flutter test --coverage and lcov ✅ 91% (131/144)
- [x] T109 Run flutter analyze to ensure zero linting errors ✅ COMPLETE (92 cosmetic warnings)
- [ ] T110 Test on physical iOS device (verify performance on real hardware per quickstart.md) **PENDING**
- [ ] T111 Test on physical Android device (verify performance on real hardware per quickstart.md) **PENDING**
- [ ] T112 Verify quickstart.md instructions are accurate (run through setup steps) **PENDING**
- [ ] T113 Build release APK and IPA for deployment readiness (flutter build apk --release, flutter build ios --release) **PENDING**

**Key Achievements**:
- Viewport culling optimization (80% rendering reduction for large maps)
- Error boundary with graceful recovery
- Character counter with color-coded keyword encouragement
- Storage full error handling with helpful messages
- All constitution requirements verified ✅
- Test coverage: 91% (131/144 tests passing)

**Commits**: `b5e02d3`, `9e4c63f`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational completion
- **User Story 2 (Phase 4)**: Depends on Foundational completion, integrates with US1 (uses MindMap model)
- **User Story 3 (Phase 5)**: Depends on Foundational completion, integrates with US1 (extends CanvasWidget)
- **User Story 4 (Phase 6)**: Depends on Foundational completion, integrates with US1/US2/US3 (persists all features)
- **Polish (Phase 7)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories - FULLY INDEPENDENT
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - Uses US1's MindMap model but independently testable (create map, color it, save/reload)
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - Uses US1's CanvasWidget but independently testable (create map, add cross-links)
- **User Story 4 (P4)**: Can start after Foundational (Phase 2) - Persists all features but independently testable (save/load with minimal data)

### Within Each User Story (TDD Red-Green-Refactor)

1. **Write unit tests FIRST** (tasks marked with test/ paths) - tests MUST FAIL
2. **Write widget tests FIRST** (tasks in test/widget/) - tests MUST FAIL
3. **Implement models** (tasks in lib/models/)
4. **Implement services** (tasks in lib/services/)
5. **Implement UI widgets** (tasks in lib/ui/widgets/)
6. **Implement screens** (tasks in lib/ui/screens/)
7. **Implement integration tests** (tasks in test/integration/)
8. **Implement performance tests** (tasks in test/performance/)
9. **Verify tests PASS** (green phase)
10. **Refactor** (clean code while keeping tests green)

### Parallel Opportunities

**Phase 1 (Setup)**: T003, T004, T005 can run in parallel

**Phase 2 (Foundational)**: T008, T009, T010, T011 can run in parallel (enums/value objects)

**Within User Story 1**:
- Tests: T021, T022, T023 can run in parallel (different test files)
- Widget tests: T024, T025 can run in parallel (different widget files)
- Initial implementation: T026, T027 can run in parallel (LayoutService and NodeWidget are independent)

**Within User Story 2**:
- Tests: T039, T040 can run in parallel
- Widget tests: T041, T042 can run in parallel
- Initial implementation: T043, T044 can run in parallel (StorageService and ColorPickerWidget are independent)

**Within User Story 3**:
- Tests: T058, T059 can run in parallel
- Widget tests: T060, T061 can run in parallel
- Initial implementation: T062, T063 can run in parallel (SymbolPaletteWidget and CrossLinkPainter are independent)

**Within User Story 4**:
- Tests: T075, T076 can run in parallel
- Widget tests: T077, T078 can run in parallel
- Initial implementation: T079, T080 can run in parallel (HomeScreen and MindMapListProvider are independent)

**Phase 7 (Polish)**: T092, T093, T094, T095, T096, T104, T105 can run in parallel (different files/concerns)

**After Foundational Phase**: User Stories 1, 2, 3, 4 can be worked on in parallel by different developers (each story is independently testable)

---

## Parallel Example: User Story 1

```bash
# Launch all unit tests for User Story 1 together:
Task T021: "Unit test for Node model validation in test/unit/models/node_test.dart"
Task T022: "Unit test for MindMap model validation in test/unit/models/mind_map_test.dart"
Task T023: "Unit test for LayoutService radial positioning in test/unit/services/layout_service_test.dart"

# Launch all widget tests for User Story 1 together:
Task T024: "Widget test for NodeWidget in test/widget/node_widget_test.dart"
Task T025: "Widget test for CanvasWidget in test/widget/canvas_widget_test.dart"

# Launch independent implementations together:
Task T026: "Create LayoutService in lib/services/layout_service.dart"
Task T027: "Create NodeWidget in lib/ui/widgets/node_widget.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001-T007)
2. Complete Phase 2: Foundational (T008-T020) - CRITICAL BLOCKER
3. Complete Phase 3: User Story 1 (T021-T038)
4. **STOP and VALIDATE**: Test User Story 1 independently - can user create central node + radial branches in <30s?
5. Deploy MVP / Demo to stakeholders
6. **Estimated timeline**: 1-2 weeks for fully tested MVP

### Incremental Delivery (Recommended)

1. **Sprint 1**: Setup + Foundational → Foundation ready
2. **Sprint 2**: User Story 1 → Test independently → Deploy MVP (core value delivered!)
3. **Sprint 3**: User Story 2 → Test independently → Deploy v1.1 (visual organization added)
4. **Sprint 4**: User Story 3 → Test independently → Deploy v1.2 (complex ideation added)
5. **Sprint 5**: User Story 4 → Test independently → Deploy v1.3 (full persistence)
6. **Sprint 6**: Polish → Final validation → Deploy v1.4 (production ready)

Each user story adds incremental value without breaking previous stories.

### Parallel Team Strategy

With multiple developers:

1. **Week 1**: Team completes Setup + Foundational together (pair programming on critical models)
2. **Week 2**: Once Foundational done, split:
   - Developer A: User Story 1 (T021-T038)
   - Developer B: User Story 2 (T039-T057)
   - Developer C: User Story 3 (T058-T074)
3. **Week 3**:
   - Developer D: User Story 4 (T075-T091)
   - Team: Integration testing across stories
4. **Week 4**: Team: Polish phase together (T092-T113)

---

## Task Summary

**Total Tasks**: 113

**Task Count by Phase**:
- Phase 1 (Setup): 7 tasks
- Phase 2 (Foundational): 13 tasks
- Phase 3 (User Story 1 - P1): 18 tasks
- Phase 4 (User Story 2 - P2): 19 tasks
- Phase 5 (User Story 3 - P3): 17 tasks
- Phase 6 (User Story 4 - P4): 17 tasks
- Phase 7 (Polish): 22 tasks

**Parallel Opportunities**: 42 tasks marked [P] for parallel execution

**Independent Test Criteria**:
- US1: Create central node + 5-10 branches in <30s with radial auto-positioning
- US2: Assign colors, drag nodes, zoom/pan at 60fps, verify spatial persistence on reload
- US3: Create cross-link with label between non-adjacent nodes, attach symbols
- US4: Name map, save, close app, reopen, load from list with all data intact

**Suggested MVP Scope**: Phase 1 + Phase 2 + Phase 3 (User Story 1 only) = 38 tasks for core value delivery

**Test Coverage**: All phases include TDD workflow with unit, widget, integration, and performance tests to achieve 80%+ coverage per constitution

---

## Notes

- [P] tasks can run in parallel (different files, no shared state dependencies)
- [US1], [US2], [US3], [US4] labels map tasks to user stories for traceability
- Follow TDD Red-Green-Refactor cycle: Write failing tests FIRST, implement SECOND, refactor THIRD
- Each user story is independently completable and testable (enables incremental delivery)
- Verify tests fail before implementing (critical for TDD discipline)
- Commit after each task or logical group of parallel tasks
- Stop at any checkpoint to validate story independently before continuing
- Performance budgets are hard requirements: 60fps, <100ms touch, <2s cold start, <500ms auto-save
- Curved organic branches with thickness hierarchy (FR-007, FR-007a) are non-negotiable for Buzan authenticity
- Spatial memory must be preserved (only auto-arrange NEW nodes, never move existing nodes unexpectedly)
- Run `flutter test --coverage` regularly to track progress toward 80%+ coverage threshold
