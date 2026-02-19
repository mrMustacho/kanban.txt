import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kanban_txt/features/todo_file/presentation/providers.dart';
import 'package:kanban_txt/shared/providers/providers.dart';
import 'package:kanban_txt/features/kanban_board/presentation/providers/kanban_provider.dart';
import 'package:kanban_txt/core/constants/app_constants.dart';

/// Header showing current file path and option to change file
class FileInfoHeader extends ConsumerWidget {
  const FileInfoHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilePath = ref.watch(currentFilePathProvider);

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current File:',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  currentFilePath ?? 'No file selected',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          ElevatedButton.icon(
            onPressed: () => _selectFile(context, ref),
            icon: const Icon(Icons.folder_open),
            label: const Text('Change'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectFile(BuildContext context, WidgetRef ref) async {
    final todoFileRepository = ref.read(todoFileRepositoryProvider);

    try {
      final filePath = await todoFileRepository.selectFile();
      if (filePath != null) {
        ref.read(currentFilePathProvider.notifier).state = filePath;
        ref.refresh(kanbanBoardWithRefreshProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File loaded successfully')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading file: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
