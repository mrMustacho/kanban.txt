import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban_txt/features/kanban_board/presentation/providers/kanban_provider.dart';
import 'package:kanban_txt/features/kanban_board/presentation/widgets/kanban_column.dart';
import 'package:kanban_txt/core/constants/app_constants.dart';

/// Kanban board widget displaying all columns
class KanbanBoardWidget extends ConsumerWidget {
  const KanbanBoardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardAsync = ref.watch(kanbanBoardWithRefreshProvider);

    return boardAsync.when(
      data: (board) {
        if (board == null) {
          return Center(
            child: Text(
              'No file loaded',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        if (board.columnOrder.isEmpty) {
          return Center(
            child: Text(
              'No tasks found',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final listTag in board.columnOrder)
                KanbanColumn(
                  listTag: listTag,
                  tasks: board.getColumn(listTag),
                ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Text(
            'Error loading board: $error',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ),
    );
  }
}
