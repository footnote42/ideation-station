# Data Model: Mobile Mind Mapping Application

**Feature**: 001-mind-map-mvp
**Created**: 2025-12-26
**Purpose**: Define domain entities, relationships, state management, and persistence strategy

## Entity Definitions

### MindMap

The root entity representing a complete mind mapping session.

**Attributes**:
- `id`: String (UUID) - Unique identifier
- `name`: String - User-assigned name for the mind map
- `createdAt`: DateTime - Timestamp of creation
- `lastModifiedAt`: DateTime - Timestamp of last edit
- `centralNode`: Node - Reference to the central node (exactly one)
- `nodes`: List<Node> - All branch and sub-branch nodes
- `crossLinks`: List<CrossLink> - Associative connections between nodes

**Validation Rules**:
- `name` MUST NOT be empty
- `name` MUST be unique across all saved mind maps
- MUST have exactly one `centralNode`
- `lastModifiedAt` MUST be >= `createdAt`

**State Transitions**:
- Created → Editing (user adds/modifies nodes)
- Editing → Saving (auto-save or manual save triggered)
- Saving → Saved (persisted to storage)
- Saved → Editing (user makes changes)

---

### Node

Represents a concept in the mind map (central, branch, or sub-branch).

**Attributes**:
- `id`: String (UUID) - Unique identifier
- `text`: String - Keyword or short phrase (1-4 words recommended)
- `type`: NodeType enum - CENTRAL, BRANCH, or SUB_BRANCH
- `position`: Position - X, Y coordinates on canvas
- `color`: Color - Visual styling (hex color code)
- `symbols`: List<Symbol> - Attached visual symbols (optional, 0-n)
- `parentId`: String? - Reference to parent node (null for central node)
- `childIds`: List<String> - References to child nodes

**Validation Rules**:
- `text` MUST NOT be empty (minimum 1 character)
- `text` SHOULD be <= 20 characters (soft limit, warning only)
- `type` MUST be CENTRAL if `parentId` is null
- `type` MUST NOT be CENTRAL if `parentId` is not null
- Central node position SHOULD be (0, 0) in normalized coordinates
- `color` MUST be valid hex color code
- Circular parent-child relationships MUST be prevented

**Derived Properties**:
- `depth`: int - Distance from central node (0 for central, 1 for branches, 2+ for sub-branches)
- `siblings`: List<Node> - Other nodes sharing same parent
- `descendants`: List<Node> - All child nodes recursively

---

### Position

Value object representing node location on infinite canvas.

**Attributes**:
- `x`: double - Horizontal coordinate (canvas units)
- `y`: double - Vertical coordinate (canvas units)

**Normalization**:
- Canvas center is (0, 0)
- Positive X = right, Negative X = left
- Positive Y = down, Negative Y = up
- Units are device-independent pixels (dp)

---

### CrossLink

Represents an associative connection between non-hierarchical nodes.

**Attributes**:
- `id`: String (UUID) - Unique identifier
- `sourceNodeId`: String - Reference to source node
- `targetNodeId`: String - Reference to target node
- `label`: String? - Optional relationship description
- `createdAt`: DateTime - Timestamp of creation

**Validation Rules**:
- `sourceNodeId` and `targetNodeId` MUST reference existing nodes
- `sourceNodeId` MUST NOT equal `targetNodeId` (no self-links)
- Duplicate links between same nodes SHOULD be prevented (soft rule)
- `label` IF present MUST be <= 30 characters

**Visual Differentiation**:
- Rendered with dashed or dotted line style (vs solid hierarchical lines)
- Different color (e.g., gray vs node color)
- Optional arrow to indicate directionality

---

### Symbol

Represents a visual icon attached to a node.

**Attributes**:
- `type`: SymbolType enum - Predefined symbol (STAR, LIGHTBULB, QUESTION, CHECK, WARNING, HEART, etc.)
- `position`: SymbolPosition enum - Relative to node (TOP_RIGHT, BOTTOM_LEFT, etc.)

**Available Symbol Types**:
- STAR - Important/favorite
- LIGHTBULB - Idea/insight
- QUESTION - Needs clarification
- CHECK - Completed/validated
- WARNING - Caution/risk
- HEART - Emotional significance
- ARROW_UP - Increase/growth
- ARROW_DOWN - Decrease/decline

**Validation Rules**:
- A node MAY have multiple symbols
- Same symbol type MAY appear multiple times on a node
- Symbol rendering MUST NOT obscure node text

---

## Relationships

### Hierarchical (Parent-Child)

- **MindMap 1:1 Node** (central node)
- **Node 1:N Node** (parent to children)
- Tree structure with single root (central node)
- Depth-first traversal for rendering order

### Associative (Cross-Links)

- **Node M:N Node** via CrossLink
- Graph structure overlay on tree
- Bidirectional visual representation (can traverse in either direction)

### Composition

- **MindMap owns Nodes** - nodes deleted when mind map deleted
- **MindMap owns CrossLinks** - links deleted when mind map deleted
- **Node contains Symbols** - symbols are value objects, not independent entities

---

## State Management Strategy

### Global State

**MindMapRepository**:
- Manages list of all saved mind maps (metadata only)
- Provides CRUD operations for mind maps
- Handles persistence coordination

### Local State (per canvas screen)

**ActiveMindMapState**:
- Currently loaded mind map
- Undo/redo history stack
- Dirty flag (unsaved changes)
- Selected nodes (for multi-select operations)
- Current interaction mode (VIEW, EDIT_NODE, CREATE_LINK, etc.)

**CanvasViewState**:
- Zoom level (0.5x - 2.0x)
- Pan offset (viewport position)
- Selected node (for single-select)
- Color picker visibility
- Symbol palette visibility

### Event-Driven Updates

- Node position changed → trigger auto-save timer
- Node added/deleted → mark dirty, update layout
- Cross-link created → mark dirty, re-render
- Color changed → mark dirty, propagate to children
- 500ms debounce on auto-save trigger

---

## Persistence Strategy

### File System Structure

```
<app_documents_directory>/
└── mindmaps/
    ├── <uuid-1>.json       # Mind map 1
    ├── <uuid-2>.json       # Mind map 2
    └── index.json           # Metadata index (names, timestamps)
```

### JSON Schema (Mind Map)

```json
{
  "id": "uuid-string",
  "name": "My Creative Ideas",
  "createdAt": "2025-12-26T10:30:00Z",
  "lastModifiedAt": "2025-12-26T11:45:00Z",
  "centralNode": {
    "id": "uuid-string",
    "text": "Main Idea",
    "type": "CENTRAL",
    "position": {"x": 0.0, "y": 0.0},
    "color": "#3498db",
    "symbols": [],
    "parentId": null,
    "childIds": ["uuid-2", "uuid-3"]
  },
  "nodes": [
    {
      "id": "uuid-2",
      "text": "Branch 1",
      "type": "BRANCH",
      "position": {"x": 150.0, "y": -50.0},
      "color": "#e74c3c",
      "symbols": [{"type": "STAR", "position": "TOP_RIGHT"}],
      "parentId": "uuid-1",
      "childIds": []
    }
  ],
  "crossLinks": [
    {
      "id": "uuid-10",
      "sourceNodeId": "uuid-2",
      "targetNodeId": "uuid-5",
      "label": "related to",
      "createdAt": "2025-12-26T11:30:00Z"
    }
  ]
}
```

### Serialization Approach

- Use `json_serializable` package for automatic JSON encoding/decoding
- Generate `fromJson` and `toJson` methods for all entities
- Immutable data classes using `@immutable` annotation
- Value equality using `equatable` package (for state comparison, undo/redo)

### Performance Considerations

- Lazy load mind map list (load index.json first, full maps on demand)
- Incremental saves (only write changed mind map, not entire index)
- Background isolate for large JSON serialization (>1000 nodes)
- Compression for storage (gzip) if maps exceed 1MB

---

## Validation & Constraints

### Domain Invariants

1. **Single Central Node**: Every mind map MUST have exactly one node with type CENTRAL
2. **Acyclic Hierarchy**: Parent-child relationships MUST form directed acyclic graph (tree)
3. **Referential Integrity**: All `parentId`, `childIds`, cross-link node references MUST be valid
4. **Unique IDs**: All node and link IDs MUST be globally unique within a mind map

### Performance Constraints

- Node position updates MUST complete in <16ms (single frame)
- JSON serialization for typical map (50 nodes) MUST complete in <100ms
- Deserialization MUST complete in <200ms for app cold start budget
- Auto-save MUST NOT block UI interaction

### Data Integrity

- Write-ahead logging for auto-save (temp file → atomic rename)
- Validation on deserialization (reject corrupt files gracefully)
- Automatic backup before destructive operations (delete mind map)

---

## Migration Strategy

Since this is MVP:
- No schema versioning yet (assume v1.0.0 format)
- Future migrations will add `schemaVersion` field to JSON
- Backward compatibility handled via optional fields with defaults

---

## Open Questions (Resolved via Research)

~~Q: Should we use freezed for immutable data classes?~~
A: Decided in research.md - see Phase 0 output

~~Q: How to handle large mind maps (>1000 nodes) efficiently?~~
A: Out of scope for MVP - optimize if needed in v2 based on user feedback
