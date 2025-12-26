# Storage Service Contract

**Feature**: 001-mind-map-mvp
**Purpose**: Define the interface for mind map persistence operations

## Interface Definition

### MindMapStorageService

Abstract interface for storing and retrieving mind maps from local device storage.

```dart
abstract class MindMapStorageService {
  /// Lists all saved mind maps (metadata only)
  /// Returns list sorted by lastModifiedAt descending (most recent first)
  Future<List<MindMapMetadata>> listMindMaps();

  /// Loads a complete mind map by ID
  /// Throws MindMapNotFoundException if ID doesn't exist
  /// Throws CorruptDataException if JSON is invalid
  Future<MindMap> loadMindMap(String id);

  /// Saves a mind map (create or update)
  /// Atomically writes to filesystem with rollback on failure
  /// Returns updated MindMap with new lastModifiedAt timestamp
  Future<MindMap> saveMindMap(MindMap mindMap);

  /// Deletes a mind map by ID
  /// Throws MindMapNotFoundException if ID doesn't exist
  /// Creates backup before deletion
  Future<void> deleteMindMap(String id);

  /// Checks if a mind map name is unique
  /// Used for validation before save
  Future<bool> isNameUnique(String name, {String? excludeId});
}
```

## Data Transfer Objects

### MindMapMetadata

Lightweight representation for listing saved mind maps.

```dart
class MindMapMetadata {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime lastModifiedAt;
  final int nodeCount;  // Derived from full mind map
}
```

## Error Handling

### Custom Exceptions

```dart
class MindMapNotFoundException implements Exception {
  final String id;
  MindMapNotFoundException(this.id);
}

class CorruptDataException implements Exception {
  final String filePath;
  final String reason;
  CorruptDataException(this.filePath, this.reason);
}

class StorageQuotaExceededException implements Exception {
  final int requiredBytes;
  final int availableBytes;
  StorageQuotaExceededException(this.requiredBytes, this.availableBytes);
}
```

## Implementation Contract

### File System Layout

```
<app_documents_directory>/mindmaps/
├── index.json                    # Metadata index
├── <uuid-1>.json                 # Mind map 1
├── <uuid-2>.json                 # Mind map 2
└── backups/
    └── <uuid-1>_<timestamp>.json  # Backup before delete
```

### Atomic Write Protocol

1. Write to temporary file: `<uuid>.json.tmp`
2. Validate written JSON can be deserialized
3. Atomic rename: `<uuid>.json.tmp` → `<uuid>.json`
4. Update index.json
5. Delete temp file on success

### Performance Requirements

- `listMindMaps()`: MUST complete in <50ms (read index.json only, not full maps)
- `loadMindMap()`: MUST complete in <200ms for typical map (50 nodes)
- `saveMindMap()`: MUST complete in <500ms (includes debounce for auto-save)
- `deleteMindMap()`: MUST complete in <100ms

### Concurrency

- Single writer (UI thread owns saves)
- Background isolate for serialization if map >1000 nodes
- File locking not required (single-user app)

## Usage Examples

### Loading Mind Map List

```dart
final storage = MindMapStorageService.instance;
final maps = await storage.listMindMaps();
// maps[0].name == "My Creative Ideas"
// maps[0].nodeCount == 42
```

### Creating New Mind Map

```dart
final newMap = MindMap(
  id: Uuid().v4(),
  name: "Project Brainstorm",
  createdAt: DateTime.now(),
  lastModifiedAt: DateTime.now(),
  centralNode: Node(...),
  nodes: [],
  crossLinks: [],
);
await storage.saveMindMap(newMap);
```

### Auto-Save on Edit

```dart
// Debounced save triggered 500ms after last edit
Timer? _autoSaveTimer;

void onNodePositionChanged(Node node) {
  _autoSaveTimer?.cancel();
  _autoSaveTimer = Timer(Duration(milliseconds: 500), () async {
    await storage.saveMindMap(currentMindMap);
  });
}
```

### Handling Errors

```dart
try {
  final map = await storage.loadMindMap(id);
} on MindMapNotFoundException {
  showError("Mind map not found");
} on CorruptDataException catch (e) {
  showError("Cannot load mind map: ${e.reason}");
  // Offer to restore from backup
}
```

## Testing Contract

### Unit Tests Required

- Serialization round-trip (save → load → verify equality)
- Atomic write rollback on failure
- Index update on create/delete
- Name uniqueness validation
- Error handling for corrupt JSON
- Error handling for missing files

### Integration Tests Required

- End-to-end save/load with real file system
- Concurrent save operations (stress test)
- Storage quota exceeded scenario
- File permission errors

## Implementation Notes

- Use `path_provider` package for platform-specific documents directory
- Use `json_serializable` for automatic JSON encoding/decoding
- Consider compression (gzip) for maps >1MB (post-MVP optimization)
- Backup retention: keep last 5 deleted maps, auto-clean older backups
