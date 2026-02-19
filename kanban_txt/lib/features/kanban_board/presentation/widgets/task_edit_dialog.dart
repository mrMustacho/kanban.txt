import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/task.dart';
import 'package:kanban_txt/features/kanban_board/presentation/providers/kanban_provider.dart';
import 'package:kanban_txt/core/constants/app_constants.dart';

typedef OnSaveCallback = Future<void> Function(String description, String listTag);
typedef OnDeleteCallback = Future<void> Function();

/// Dialog for creating or editing a task
class TaskEditDialog extends ConsumerStatefulWidget {
  final Task? task; // null for create, non-null for edit
  final OnSaveCallback onSave;
  final OnDeleteCallback? onDelete;

  const TaskEditDialog({
    Key? key,
    this.task,
    required this.onSave,
    this.onDelete,
  }) : super(key: key);

  /// Factory constructor for creating a new task
  factory TaskEditDialog.create({
    required OnSaveCallback onSave,
  }) {
    return TaskEditDialog(
      task: null,
      onSave: onSave,
    );
  }

  @override
  ConsumerState<TaskEditDialog> createState() => _TaskEditDialogState();
}

class _TaskEditDialogState extends ConsumerState<TaskEditDialog> {
  late TextEditingController _descriptionController;
  late String _selectedListTag;
  late bool _isCompleted;
  late String? _priority;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _selectedListTag = widget.task?.listTag ?? AppConstants.defaultListTagBacklog;
    _isCompleted = widget.task?.isCompleted ?? false;
    _priority = widget.task?.priority;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boardAsync = ref.watch(kanbanBoardWithRefreshProvider);

    return AlertDialog(
      title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Description field
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter task description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // List tag dropdown
            boardAsync.when(
              data: (board) {
                final columnTags = board?.columnOrder ?? [];
                if (columnTags.isEmpty) {
                  return const SizedBox.shrink();
                }

                return DropdownButtonFormField<String>(
                  value: _selectedListTag,
                  items: columnTags
                      .map((tag) => DropdownMenuItem(
                        value: tag,
                        child: Text(tag),
                      ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedListTag = value ?? AppConstants.defaultListTagBacklog);
                  },
                  decoration: const InputDecoration(
                    labelText: 'List/Column',
                    border: OutlineInputBorder(),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Completion checkbox
            if (widget.task != null)
              CheckboxListTile(
                title: const Text('Completed'),
                value: _isCompleted,
                onChanged: (value) {
                  setState(() => _isCompleted = value ?? false);
                },
              ),

            // Priority dropdown
            DropdownButtonFormField<String?>(
              value: _priority,
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('No Priority'),
                ),
                ...['A', 'B', 'C'].map((p) => DropdownMenuItem(
                  value: p,
                  child: Text('Priority $p'),
                )),
              ],
              onChanged: (value) {
                setState(() => _priority = value);
              },
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        if (widget.task != null && widget.onDelete != null)
          TextButton(
            onPressed: () async {
              await widget.onDelete!();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ElevatedButton(
          onPressed: () => _save(),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Description cannot be empty')),
      );
      return;
    }

    try {
      await widget.onSave(_descriptionController.text.trim(), _selectedListTag);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
