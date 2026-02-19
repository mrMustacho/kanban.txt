import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/task.dart';
import 'package:kanban_txt/features/kanban_board/presentation/widgets/task_card.dart';
import 'package:kanban_txt/features/kanban_board/presentation/providers/filter_provider.dart';
import 'package:kanban_txt/core/constants/app_constants.dart';

/// Single Kanban column for a list tag
class KanbanColumn extends ConsumerWidget {
  final String listTag;
  final List<Task> tasks;

  const KanbanColumn({
    Key? key,
    required this.listTag,
    required this.tasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    final filteredTasks = tasks.where((t) => filter.matches(t)).toList();

    return Container(
      width: 320,
      margin: const EdgeInsets.all(AppConstants.paddingSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.columnBorderRadius),
      ),
      child: Column(
        children: [
          // Column header
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.columnBorderRadius),
                topRight: Radius.circular(AppConstants.columnBorderRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  listTag,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingSmall,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${filteredTasks.length}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tasks list
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
                    child: Text(
                      'No tasks',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.paddingSmall),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppConstants.paddingSmall,
                        ),
                        child: TaskCard(task: task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
