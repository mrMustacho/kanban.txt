import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/task.dart';
import 'package:kanban_txt/features/kanban_board/presentation/widgets/task_edit_dialog.dart';
import 'package:kanban_txt/features/kanban_board/presentation/providers/task_provider.dart';
import 'package:kanban_txt/core/constants/app_constants.dart';

/// Task card displayed in a column
class TaskCard extends ConsumerWidget {
  final Task task;

  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showEditDialog(context, ref),
      child: Card(
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            border: Border(
              left: BorderSide(
                color: task.isCompleted
                    ? Theme.of(context).colorScheme.outlineVariant
                    : task.priority != null
                        ? _priorityColor(task.priority!, context)
                        : Theme.of(context).colorScheme.primary,
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task description
              Text(
                task.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted
                      ? Theme.of(context).textTheme.bodySmall?.color
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              // Metadata row
              Row(
                children: [
                  if (task.priority != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _priorityColor(task.priority!, context).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        task.priority!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _priorityColor(task.priority!, context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  if (task.contexts.isNotEmpty)
                    Flexible(
                      child: Text(
                        task.contexts.join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                ],
              ),
              if (task.projects.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  task.projects.join(', '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => TaskEditDialog(
        task: task,
        onSave: (description, listTag) async {
          final taskService = ref.read(taskServiceProvider);
          final updatedTask = task.copyWith(
            description: description,
            listTag: listTag,
          );
          await taskService.updateTask(updatedTask);
          if (context.mounted) Navigator.pop(context);
        },
        onDelete: () async {
          final taskService = ref.read(taskServiceProvider);
          await taskService.deleteTask(task.id);
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }

  Color _priorityColor(String priority, BuildContext context) {
    switch (priority) {
      case 'A':
        return Colors.red;
      case 'B':
        return Colors.orange;
      case 'C':
        return Colors.blue;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
