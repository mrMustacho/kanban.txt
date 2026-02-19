import 'package:kanban_txt/core/constants/app_constants.dart';
import 'package:kanban_txt/core/extensions/string_extensions.dart';
import 'package:kanban_txt/core/utils/logger.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/kanban_board.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/task.dart';

/// Datasource for parsing and formatting todo.txt files
class TodoParserDatasource {
  /// Parse raw todo.txt content into a list of Task objects
  List<Task> parseTodoContent(String rawContent) {
    final lines = rawContent.split('\n');
    final tasks = <Task>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trim().isEmpty) continue;

      try {
        final task = _parseTaskLine(line, i);
        tasks.add(task);
      } catch (e) {
        logger.w('Failed to parse line $i: $e');
      }
    }

    return tasks;
  }

  /// Parse a single task line
  Task _parseTaskLine(String line, int lineIndex) {
    // Parse completion, priority, dates, and description
    final parsed = line.parseTodoLine();

    final description = parsed['text'] as String;
    final isCompleted = parsed['isCompleted'] as bool;
    final priority = parsed['priority'] as String?;
    final creationDate = parsed['creationDate'] as DateTime?;
    final completionDate = parsed['completionDate'] as DateTime?;

    // Extract metadata
    final contexts = description.extractContexts();
    final projects = description.extractProjects();
    final allTags = description.extractKeyValues();

    // Extract list tag (determines column)
    final listTag = allTags.remove(AppConstants.listTagKey) ?? AppConstants.defaultListTagBacklog;

    // Generate unique ID
    final id = _generateTaskId(lineIndex, description);

    // Create task
    return Task(
      id: id,
      originalLine: line,
      isCompleted: isCompleted,
      priority: priority,
      creationDate: creationDate,
      completionDate: completionDate,
      description: description,
      contexts: contexts,
      projects: projects,
      tags: allTags,
      listTag: listTag,
    );
  }

  /// Generate a unique ID for a task
  String _generateTaskId(int lineIndex, String description) {
    return '${lineIndex}_${description.hashCode}';
  }

  /// Convert a Task back to todo.txt format
  String formatTaskToLine(Task task) {
    final parts = <String>[];

    // Completion marker
    if (task.isCompleted) {
      parts.add('x');
      if (task.completionDate != null) {
        parts.add(_formatDate(task.completionDate!));
      }
    }

    // Priority
    if (task.priority != null && !task.isCompleted) {
      parts.add('(${task.priority})');
    }

    // Creation date
    if (task.creationDate != null) {
      parts.add(_formatDate(task.creationDate!));
    }

    // Description
    parts.add(task.description);

    // Re-add list tag
    parts.add('${AppConstants.listTagKey}:${task.listTag}');

    // Re-add other tags
    task.tags.forEach((key, value) {
      parts.add('$key:$value');
    });

    return parts.join(' ');
  }

  /// Format a DateTime to todo.txt date format (YYYY-MM-DD)
  String _formatDate(DateTime date) {
    return date.toString().substring(0, 10);
  }

  /// Build a KanbanBoard from parsed tasks, maintaining column order
  KanbanBoard buildKanbanBoard(List<Task> tasks) {
    final columns = <String, List<Task>>{};
    final columnOrder = <String>[];

    for (final task in tasks) {
      if (!columns.containsKey(task.listTag)) {
        columns[task.listTag] = [];
        columnOrder.add(task.listTag);
      }
      columns[task.listTag]!.add(task);
    }

    return KanbanBoard(
      columns: columns,
      columnOrder: columnOrder,
    );
  }
}
