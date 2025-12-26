# Ideation Station

> A mobile-first mind mapping application for creative thinking based on Tony Buzan's methodology

**Ideation Station** is a specialized cognitive tool designed to facilitate "Radiant Thinking" — the brain's natural method of generating complex webs of association. Unlike conventional linear note-taking tools or generic diagramming apps, this project faithfully implements Tony Buzan's foundational mind mapping principles to unlock your full mental potential.

---

## Vision

This application transcends the limitations of traditional note-taking by creating a visual, non-linear environment that mirrors the brain's natural associative architecture. It prioritizes **rapid idea capture**, **visual expressiveness**, and **cognitive flow** over project management or task tracking.

### Core Differentiators

- **Buzan-Authentic Implementation**: Follows the Laws of Mind Mapping from Tony Buzan's methodology
- **Radial Structure**: Ideas radiate outward from a central concept in all directions
- **Curved Organic Branches**: Visual connections use curved, tapering lines (not straight) to maintain brain interest
- **Visual Hierarchy**: Main branches are thicker than sub-branches for clear cognitive organization
- **Keyword-Based Nodes**: Promotes precise association and "infinite creativity"
- **Spatial Memory Preservation**: Node positions persist exactly as you place them
- **Speed-Optimized for Creative Flow**: <100ms touch response, 60fps interactions

For complete methodology details, see [`mind-mapping-methodology.md`](mind-mapping-methodology.md) and [`notebooklm_urd.md`](notebooklm_urd.md).

---

## Project Status

**Current Phase**: User Story 1 Complete - MVP Functional! 🎉

- ✅ Project constitution established (v1.0.0)
- ✅ MVP feature specification complete
- ✅ Implementation plan and technical research complete
- ✅ Data model and interface contracts defined
- ✅ Task breakdown complete ([tasks.md](specs/001-mind-map-mvp/tasks.md))
- ✅ **Phase 1: Setup** - Flutter project initialized, dependencies configured
- ✅ **Phase 2: Foundational** - Core models, JSON serialization, Riverpod setup, constants
- ✅ **Phase 3: User Story 1 (Rapid Idea Capture)** - FUNCTIONAL (60 TDD tests passing)
- 🎯 **Phase 4: User Story 2 (Visual Organization)** - Next to implement

**Active Feature**: `001-mind-map-mvp` (Mobile Mind Mapping MVP)

**Latest Commits**:
- `c8d6d6f` - Fix Phase 3: Mind map rendering now working (viewport centering)
- `364a580` - Fix mind map creation (remove PostFrameCallback)
- `a497429` - Fix TextEditingController disposal timing
- `fff0a97` - Complete Phase 3 User Story 1: Rapid idea capture with TDD

---

## Technology Stack

- **Framework**: Flutter 3.38.5 (native iOS/Android)
- **Language**: Dart 3.10.4
- **Canvas Rendering**: CustomPaint + InteractiveViewer (built-in)
- **State Management**: Riverpod 2.6.1
- **Storage**: Local JSON files via path_provider 2.1.5
- **Code Generation**: Freezed 2.5.8 + json_serializable 6.9.5
- **Testing**: flutter_test, integration_test, mockito 5.4.6

For detailed technical decisions and rationale, see [`specs/001-mind-map-mvp/research.md`](specs/001-mind-map-mvp/research.md).

---

## Implementation Progress

### ✅ Completed Phases

#### Phase 1: Setup (Tasks T001-T007)
- Flutter project structure initialized
- All dependencies configured and installed
- Strict linting rules enabled
- Test directory structure created
- Development environment verified

#### Phase 2: Foundational (Tasks T008-T020)
**Core Data Models** (all with Freezed + JSON serialization):
- `Position` - Normalized canvas coordinates
- `NodeType` - Hierarchical node classification
- `NodeSymbol` - 8 visual symbols with positioning
- `Node` - Complete node model with relationships
- `CrossLink` - Associative node connections
- `MindMap` - Top-level container

**Infrastructure Ready**:
- JSON converters for Flutter types (Color, Offset)
- Riverpod state management foundation
- App constants with performance budgets
- 12-color Buzan palette
- Visual hierarchy rules (8px → 5px → 3px branch thickness)

**Quality Metrics**:
- ✅ All tests passing
- ✅ Flutter analyze clean
- ✅ 23 files created
- ✅ Freezed code generation working

### 🎯 Next Phase

**Phase 3: User Story 1 - Rapid Idea Capture** (Tasks T021-T038)

Focus: Enable central node creation and radial branch layout with <100ms touch response

See [`CLAUDE.md`](CLAUDE.md) for detailed implementation status and next steps.

---

## Key Features (MVP)

### P1: Rapid Idea Capture
- Create central node and radial branches in <30 seconds
- Touch response <100ms for instant feedback
- Auto-radial positioning to prevent overlap

### P2: Visual Organization
- Color palette with auto-color mode for branch differentiation
- Free-form drag-to-reposition nodes
- Smooth pinch-to-zoom and pan gestures (60fps)

### P3: Complex Ideation
- Cross-links between non-adjacent nodes
- Symbol palette for visual markers
- Relationship labeling

### P4: Save & Retrieve
- Local device storage (offline-first)
- Auto-save with 500ms debounce
- Mind map library with rename/delete

For complete user stories and acceptance criteria, see [`specs/001-mind-map-mvp/spec.md`](specs/001-mind-map-mvp/spec.md).

---

## Performance Budgets

These are **hard requirements** enforced by the project constitution:

- **Touch Response**: <100ms (perceived as instant)
- **Frame Rate**: 60fps (16ms budget) for all pan/zoom/node operations
- **Cold Start**: <2 seconds from tap to interactive canvas
- **Auto-Save**: <500ms without UI jank
- **Large Maps**: 100+ nodes without performance degradation

---

## Project Constitution

This project follows strict governance principles defined in [`.specify/memory/constitution.md`](.specify/memory/constitution.md):

1. **User Experience Priority** - UI interactions <100ms, first idea capture within 60 seconds
2. **Simplicity First** - YAGNI principles, justify all new dependencies
3. **Test-Driven Development** - Red-Green-Refactor cycle, 80%+ test coverage for critical paths
4. **Performance & Responsiveness** - 60fps for interactions, 16ms render budget, 2-second cold start

All features must pass constitution gates before implementation.

---

## Documentation Structure

```
├── README.md                          # This file - project overview
├── CLAUDE.md                          # Agent context for Claude Code
├── mind-mapping-methodology.md        # Buzan methodology (essential vs flexible rules)
├── notebooklm_urd.md                  # Full User Requirements Document with Buzan Laws
├── .specify/
│   └── memory/
│       └── constitution.md            # Project governance principles (v1.0.0)
└── specs/
    └── 001-mind-map-mvp/
        ├── spec.md                    # Feature specification (user stories, requirements)
        ├── plan.md                    # Implementation plan (architecture, phases)
        ├── research.md                # Technical research findings
        ├── data-model.md              # Data model design
        ├── quickstart.md              # Developer setup and TDD workflow
        └── contracts/                 # Interface definitions (storage, layout)
```

---

## Quick Start

### For Developers

1. **Setup Environment**: See [`specs/001-mind-map-mvp/quickstart.md`](specs/001-mind-map-mvp/quickstart.md) for Flutter installation and project setup

2. **Review Specification**: Read [`specs/001-mind-map-mvp/spec.md`](specs/001-mind-map-mvp/spec.md) to understand requirements

3. **Follow TDD Workflow**: All code must be written test-first (Red-Green-Refactor cycle)

4. **Check Constitution Compliance**: Ensure all features pass gates in [`.specify/memory/constitution.md`](.specify/memory/constitution.md)

### For Claude Code Agents

See [`CLAUDE.md`](CLAUDE.md) for:
- Core philosophy and design principles
- SpecKit workflow system
- Performance budgets
- Constitution compliance gates
- Key design constraints

---

## Out of Scope (MVP)

The following features are **explicitly deferred** to post-MVP (see `notebooklm_urd.md` for full roadmap):

- User authentication/accounts (eventually needed)
- Cloud synchronization across devices
- Real-time collaboration (multi-user editing)
- Presentation mode and export (PDF/PNG/Word/PowerPoint)
- AI-augmented ideation (PDF-to-mindmap, suggestion engine)
- Advanced image insertion (full image upload for nodes)
- Accessibility focus mode (neuro-inclusive design features)
- Task management (intentionally out of scope - this is a thinking tool, not a task tracker)

---

## Development Workflow (SpecKit)

This project uses a structured feature development system:

```bash
/speckit.specify <description>  # Create feature specification
/speckit.clarify                # Ask targeted clarification questions
/speckit.plan                   # Generate implementation plan
/speckit.tasks                  # Generate task breakdown
/speckit.implement              # Execute tasks in dependency order
/speckit.analyze                # Validate cross-artifact consistency
```

For complete SpecKit documentation, see [`.claude/commands/`](.claude/commands/).

---

## License

[TBD]

---

## Contact

[TBD]

---

**Remember**: This is a tool for **divergent thinking and idea exploration**, not convergent execution or task management. Every feature must support creative flow, not interrupt it.
