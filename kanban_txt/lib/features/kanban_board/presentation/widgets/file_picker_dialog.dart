import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban_txt/core/constants/app_constants.dart';
import 'package:kanban_txt/shared/providers/providers.dart';
import 'package:kanban_txt/features/kanban_board/presentation/providers/kanban_provider.dart';

/// Dialog for selecting or changing the todo.txt file
class FilePickerDialog extends ConsumerWidget {
  const FilePickerDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Select Todo.txt File'),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a todo.txt file to load into the Kanban board:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: AppConstants.paddingMedium),
            Text(
              '• Files should be in todo.txt format',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              '• Columns are created from list: tags',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              '• All changes are saved back to the file',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: () => _pickFile(context, ref),
          icon: const Icon(Icons.folder_open),
          label: const Text('Select File'),
        ),
      ],
    );
  }

  /// Pick a file and update the app state
  Future<void> _pickFile(BuildContext context, WidgetRef ref) async {
    final todoFileRepository = ref.read(todoFileRepositoryProvider);

    try {
      final filePath = await todoFileRepository.selectFile();

      if (filePath != null) {
        // Update file path in state
        ref.read(currentFilePathProvider.notifier).state = filePath;

        // Trigger board refresh
        ref.refresh(kanbanBoardWithRefreshProvider);

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Loaded: ${filePath.split('/').last}'),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          );
        }

        // Close dialog
        if (context.mounted) Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading file: $e'),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      }
    }
  }
}
