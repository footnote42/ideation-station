import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideation_station/providers/mind_map_provider.dart';
import 'package:ideation_station/ui/widgets/canvas_widget.dart';

/// Main canvas screen for mind map editing.
///
/// Features:
/// - AppBar with mind map name and actions
/// - CanvasWidget for displaying mind map
/// - Floating action button for adding nodes
/// - Node selection and editing capabilities
class CanvasScreen extends ConsumerStatefulWidget {
  final String? mindMapId;

  const CanvasScreen({
    super.key,
    this.mindMapId,
  });

  @override
  ConsumerState<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends ConsumerState<CanvasScreen> {
  String? _selectedNodeId;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Create a new mind map if none exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mindMap = ref.read(mindMapProvider);
      if (mindMap == null) {
        _showCreateMindMapDialog();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mindMap = ref.watch(mindMapProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(mindMap?.name ?? 'New Mind Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddNodeDialog,
            tooltip: 'Add Node',
          ),
        ],
      ),
      body: mindMap == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CanvasWidget(
              mindMap: mindMap,
              onNodeTap: (nodeId) {
                setState(() {
                  _selectedNodeId = nodeId;
                });
              },
            ),
      floatingActionButton: mindMap == null
          ? null
          : FloatingActionButton(
              onPressed: _showAddNodeDialog,
              tooltip: 'Add Branch',
              child: const Icon(Icons.add),
            ),
    );
  }

  /// Shows dialog to create a new mind map with central node.
  Future<void> _showCreateMindMapDialog() async {
    final nameController = TextEditingController(text: 'My Mind Map');
    final centralTextController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Create Mind Map'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Mind Map Name',
                hintText: 'Enter a name for your mind map',
              ),
              autofocus: false,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: centralTextController,
              decoration: const InputDecoration(
                labelText: 'Central Idea',
                hintText: 'Enter your main idea (keyword)',
              ),
              autofocus: true,
              onSubmitted: (_) {
                if (centralTextController.text.isNotEmpty) {
                  Navigator.of(context).pop(true);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (centralTextController.text.isNotEmpty) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      // Capture values
      final mapName = nameController.text.isNotEmpty
          ? nameController.text
          : 'My Mind Map';
      final centralText = centralTextController.text;

      // Defer state change until dialog animation completes
      // Controllers will be garbage collected automatically (they're local variables)
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) {
          ref.read(mindMapProvider.notifier).createMindMap(
                name: mapName,
                centralText: centralText,
              );
        }
      });
    }
  }

  /// Shows dialog to add a new node (branch or sub-branch).
  Future<void> _showAddNodeDialog() async {
    final mindMap = ref.read(mindMapProvider);
    if (mindMap == null) return;

    _textController.clear();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_selectedNodeId == null
            ? 'Add Branch Node'
            : 'Add Sub-Branch Node'),
        content: TextField(
          controller: _textController,
          decoration: InputDecoration(
            labelText: 'Node Text',
            hintText: _selectedNodeId == null
                ? 'Enter branch keyword'
                : 'Enter sub-branch keyword',
            helperText: 'Tip: Keep it short (1-4 words)',
          ),
          autofocus: true,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              Navigator.of(context).pop(value);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                Navigator.of(context).pop(_textController.text);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      if (_selectedNodeId == null) {
        // Add branch node to central node
        ref.read(mindMapProvider.notifier).addBranchNode(
              text: result,
            );
      } else {
        // Add sub-branch to selected node
        ref.read(mindMapProvider.notifier).addSubBranch(
              parentId: _selectedNodeId!,
              text: result,
            );
      }

      // Clear selection after adding
      setState(() {
        _selectedNodeId = null;
      });
    }
  }
}
