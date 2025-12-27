import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideation_station/providers/mind_map_list_provider.dart';
import 'package:ideation_station/providers/mind_map_provider.dart';
import 'package:ideation_station/services/storage_service.dart';
import 'package:ideation_station/ui/screens/canvas_screen.dart';

/// Home screen displaying list of saved mind maps.
///
/// Features:
/// - ListView of saved mind maps sorted by last modified
/// - Tap to open mind map in CanvasScreen
/// - Long-press for rename/delete options
/// - FAB to create new mind map
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final StorageServiceInterface _storageService = StorageService.create();

  @override
  void initState() {
    super.initState();

    // Load mind map list on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mindMapListProvider.notifier).loadMindMaps();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mindMaps = ref.watch(mindMapListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mind Maps'),
      ),
      body: mindMaps.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: mindMaps.length,
              itemBuilder: (context, index) {
                final mapMeta = mindMaps[index];
                return _buildMindMapTile(mapMeta);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewMindMap,
        tooltip: 'Create New Mind Map',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bubble_chart,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Mind Maps Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to create your first mind map',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMindMapTile(Map<String, dynamic> mapMeta) {
    final id = mapMeta['id'] as String;
    final name = mapMeta['name'] as String;
    final lastModified = DateTime.parse(mapMeta['lastModifiedAt'] as String);

    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.account_tree),
      ),
      title: Text(name),
      subtitle: Text(_formatDate(lastModified)),
      onTap: () => _openMindMap(id),
      onLongPress: () => _showContextMenu(id, name),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _openMindMap(String id) async {
    // Navigate to CanvasScreen with mind map ID
    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CanvasScreen(mindMapId: id),
        ),
      );

      // Refresh list when returning (in case map was modified)
      ref.read(mindMapListProvider.notifier).refresh();
    }
  }

  void _showContextMenu(String id, String name) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Rename'),
            onTap: () {
              Navigator.pop(context);
              _showRenameDialog(id, name);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(id, name);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showRenameDialog(String id, String currentName) async {
    final controller = TextEditingController(text: currentName);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Mind Map'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'Enter new name',
          ),
          autofocus: true,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              Navigator.pop(context, value);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context, controller.text);
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && mounted) {
      await _storageService.renameMindMap(id, result);
      ref.read(mindMapListProvider.notifier).refresh();
    }
  }

  Future<void> _showDeleteConfirmation(String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Mind Map'),
        content: Text('Are you sure you want to delete "$name"?\n\nThis action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _storageService.deleteMindMap(id);
      ref.read(mindMapListProvider.notifier).refresh();
    }
  }

  Future<void> _createNewMindMap() async {
    // Clear current mind map state
    ref.read(mindMapProvider.notifier).clearMindMap();

    // Navigate to CanvasScreen to create new map
    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CanvasScreen(),
        ),
      );

      // Refresh list when returning
      ref.read(mindMapListProvider.notifier).refresh();
    }
  }
}
