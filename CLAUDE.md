# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Ideation Station** is a mobile-first mind mapping application for creative thinking based on Tony Buzan's methodology. The app prioritizes rapid idea capture, visual expressiveness, and cognitive flow over project management or task tracking.

**Current Technology Stack**: Flutter (native iOS/Android)
**Storage**: Local device storage only (MVP)
**Current Status**: Pre-implementation - specification phase complete

## Core Philosophy (Mind Mapping Methodology)

This project implements **Buzan-style mind mapping** with specific cognitive design principles. See `mind-mapping-methodology.md` for essential vs flexible rules, and `notebooklm_urd.md` for complete User Requirements Document with full Buzan Laws.

### Non-Negotiable Design Principles

1. **Central Node First**: Every mind map begins with a single focal concept at the center
   - **SHOULD** support image selection from symbol palette (FR-001a) - images are more authentic to Buzan methodology
   - Text-only acceptable for MVP, but image encouraged for brain engagement

2. **Radial Structure**: Ideas radiate outward in all directions (NOT top-down hierarchies)
   - Main branches connect directly to central node
   - Sub-branches extend from parent branches
   - No floating or disconnected branches

3. **Curved, Organic Branches (CRITICAL - FR-007)**: Branch connections MUST be curved and organic, NOT straight lines
   - This is essential for Buzan authenticity and maintaining brain interest
   - Avoid linear, rigid visual structures that induce mental boredom
   - Visual thickness hierarchy (FR-007a): Main branches MUST be visibly thicker than sub-branches

4. **Keywords Over Sentences**: Nodes contain single keywords (gently encouraged, not enforced)
   - Promotes precise association and "infinite creativity"
   - Allow 2-4 word phrases where necessary, but discourage sentences

5. **Visual Expressiveness**: Colors, symbols, and spatial positioning are functional cognition support, not decoration
   - Auto-color mode (FR-008a): Optionally assign new color from palette to each main branch
   - Color differentiation activates right-brain processing per Buzan methodology
   - Each main branch and its children adopt branch color by default

6. **Spatial Memory**: Persistent node positioning is critical - never move nodes unexpectedly
   - Auto-arrange only newly created nodes
   - Manual positioning is preserved on save/load
   - Spatial arrangement creates cognitive anchors

7. **Speed of Capture**: "If it takes longer to add an idea than to think it, the tool breaks the method"
   - Touch response < 100ms
   - Creative flow state must not be interrupted by tool friction

8. **Landscape Orientation Preference (FR-032a)**: Default to landscape on tablets/larger devices
   - Buzan methodology prefers landscape for radial canvas space
   - Portrait + landscape both supported for mobile flexibility

### Critical "Don'ts"

- **DON'T** treat mind maps like project management tools
- **DON'T** force vertical tree layouts or linear structures
- **DON'T** use straight lines for branch connections (curves are mandatory for Buzan authenticity)
- **DON'T** implement aggressive auto-layout that moves existing nodes
- **DON'T** add task tracking or reminder features (out of scope by design)
- **DON'T** render branches with uniform visual weight (thickness hierarchy is required)

## Project Constitution

The project follows strict governance principles defined in `.specify/memory/constitution.md` (v1.0.0):

### Four Core Principles (in priority order)

1. **User Experience Priority**: UI interactions < 100ms perceived latency, first idea capture within 60 seconds
2. **Simplicity First**: YAGNI principles, reject abstractions unless pattern appears 3+ times
3. **Test-Driven Development**: Red-Green-Refactor cycle mandatory, 80%+ test coverage for critical user journeys
4. **Performance & Responsiveness**: 60 fps for pan/zoom/edit, 16ms render budget, 2-second cold start

### Branching Strategy

- Main branch: `main` (always deployable)
- Feature branches: `###-feature-name` format (e.g., `001-mind-map-mvp`)
- No direct commits to main - all changes via pull requests

## SpecKit Workflow System

This project uses a structured feature development workflow via custom Claude Code commands:

### Feature Development Workflow

```bash
# 1. Create feature specification
/speckit.specify <feature description>
# Creates: specs/###-feature-name/spec.md
# Output: User stories, functional requirements, success criteria

# 2. (Optional) Clarify underspecified areas
/speckit.clarify
# Asks targeted questions to refine spec

# 3. Generate implementation plan
/speckit.plan
# Creates: specs/###-feature-name/plan.md, research.md, data-model.md, quickstart.md, contracts/
# Includes constitution compliance checks

# 4. Generate task breakdown
/speckit.tasks
# Creates: specs/###-feature-name/tasks.md
# Tasks organized by user story with dependency tracking

# 5. Implement feature
/speckit.implement
# Executes tasks in dependency order

# 6. Analyze consistency
/speckit.analyze
# Cross-artifact validation
```

### Additional Commands

```bash
# Update project constitution
/speckit.constitution

# Generate custom checklist
/speckit.checklist

# Convert tasks to GitHub issues
/speckit.taskstoissues
```

## Directory Structure

```
specs/
  ###-feature-name/           # Feature branch number + short name
    spec.md                   # Feature specification (user stories, requirements)
    plan.md                   # Implementation plan (architecture, phases)
    research.md               # Technical research findings
    data-model.md             # Data model design
    quickstart.md             # Feature usage guide
    tasks.md                  # Task breakdown by user story
    contracts/                # API contracts or interface definitions
    checklists/
      requirements.md         # Spec quality validation

.specify/
  memory/
    constitution.md           # Project governance principles (v1.0.0)
  templates/                  # Templates for specs, plans, tasks
  scripts/bash/               # Feature creation and management scripts

.claude/
  commands/                   # SpecKit command definitions
```

## Performance Budgets (Critical for Mind Mapping)

From constitution and feature spec:

- **Touch Response**: < 100ms (perceived as instant)
- **Frame Rate**: 60 fps (16ms budget) for pan/zoom/node manipulation
- **Cold Start**: < 2 seconds from tap to interactive canvas
- **Auto-save**: < 500ms without disrupting interaction
- **Large Maps**: 100+ nodes without performance degradation

These are **hard requirements** - performance regressions block releases.

## Feature Specification Reference

Current MVP spec: `specs/001-mind-map-mvp/spec.md`

**Prioritized User Stories**:
1. P1: Rapid Idea Capture (central node + radial branches)
2. P2: Visual Organization (colors, spatial positioning, pan/zoom)
3. P3: Complex Ideation (cross-links, symbols)
4. P4: Save & Retrieve (local storage)

**Key Requirements**:
- Flutter native mobile app (iOS/Android)
- Local device storage only (no cloud sync in MVP)
- Offline-first design
- Mobile-optimized (portrait + landscape)

**Out of Scope for MVP** (deferred to post-MVP, see `notebooklm_urd.md` for full requirements):
- User authentication/accounts (eventually needed per spec)
- Cloud synchronization across devices
- Real-time collaboration (multi-user editing - see notebooklm_urd.md section 4.1)
- Presentation mode and data export (PDF/PNG - see notebooklm_urd.md section 4.2)
- AI-augmented ideation (PDF-to-mindmap, suggestion engine - see notebooklm_urd.md section 4.3)
- Advanced image insertion (full image upload for nodes - symbol palette only in MVP)
- Accessibility focus mode (neuro-inclusive design - see notebooklm_urd.md section 5.2)
- Task management (intentionally out of scope - this is a thinking tool, not a task tracker)

## Constitution Compliance

Before implementing any feature:

1. **Check Constitution Gates** (in plan.md):
   - User scenarios defined with acceptance criteria
   - Solution is simplest that meets requirements
   - Test strategy defined (TDD workflow)
   - Performance budgets established

2. **Avoid Complexity Violations**:
   - Justify new dependencies
   - Document why simpler alternatives insufficient
   - No premature abstractions

3. **Performance First**:
   - Measure before optimizing
   - Maintain 60 fps interaction targets
   - Test on standard mobile hardware

## Working with Features

When working on a feature branch:

```bash
# Feature branches are created automatically by /speckit.specify
git checkout ###-feature-name

# All feature artifacts live in specs/###-feature-name/
# Reference spec.md for requirements
# Reference plan.md for architecture decisions
# Reference tasks.md for implementation order
```

## Key Design Constraints

1. **Radial Layout Algorithm**: Must distribute nodes evenly around center, avoid overlap, preserve spatial relationships during zoom/pan

2. **Curved Organic Branches (FR-007)**: Branch connections MUST use curved, tapering lines (NOT straight lines)
   - This is non-negotiable for Buzan authenticity
   - Use bezier curves or similar organic flow
   - Avoid rigid, linear visual structures

3. **Visual Thickness Hierarchy (FR-007a)**: Main branches MUST be visibly thicker than sub-branches
   - Creates clear visual hierarchy
   - Essential for Buzan methodology compliance
   - Thickness should taper naturally from thick (main) to thin (sub-branches)

4. **Keyword Encouragement**: Gently discourage long phrases (e.g., character counter, visual cue) but don't enforce rigidly
   - Promote single keywords for "infinite creativity"
   - Allow 2-4 word phrases where conceptually necessary

5. **Spatial Memory Preservation**: Only auto-arrange NEW nodes - never move existing nodes unexpectedly
   - Spatial positioning creates cognitive anchors
   - Manual repositioning is preserved on save/load

6. **Auto-Color Mode (FR-008a)**: Optionally assign new color from palette to each main branch
   - Supports Buzan principle of color differentiation
   - Children inherit parent branch color by default
   - User can override colors manually

7. **Creative Flow Protection**: Any feature that increases friction or cognitive load violates core philosophy
   - Touch response < 100ms is mandatory
   - No interruptions during rapid idea capture

8. **Thinking vs Tracking**: This is a tool for divergent thinking and idea exploration, not convergent execution or task management

## When to Reference Documentation

- **Mind mapping behavior (essential vs flexible rules)**: See `mind-mapping-methodology.md`
- **Buzan methodology (full User Requirements Document)**: See `notebooklm_urd.md` for complete Buzan Laws and advanced features roadmap
- **Governance/workflow**: See `.specify/memory/constitution.md`
- **Feature requirements**: See `specs/###-feature-name/spec.md`
- **Implementation architecture**: See `specs/###-feature-name/plan.md`
- **Task execution order**: See `specs/###-feature-name/tasks.md`
- **Developer setup and TDD workflow**: See `specs/###-feature-name/quickstart.md`

## Active Technologies
- Dart 3.2+ with Flutter 3.16+ SDK (001-mind-map-mvp)
- Local JSON files via path_provider (mobile filesystem) (001-mind-map-mvp)

## Recent Changes
- 001-mind-map-mvp: Added Dart 3.2+ with Flutter 3.16+ SDK
