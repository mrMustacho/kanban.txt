import 'task.dart';

class KanbanBoard {
  final Map<String, List<Task>> columns; // Map: listTag -> List<Task>
  final List<String> columnOrder; // Order of columns

  KanbanBoard({
    required this.columns,
    required this.columnOrder,
  });

  /// Get all tasks across all columns
  List<Task> get allTasks {
    final result = <Task>[];
    for (final columnTasks in columns.values) {
      result.addAll(columnTasks);
    }
    return result;
  }

  /// Get tasks for a specific column
  List<Task> getColumn(String listTag) => columns[listTag] ?? [];

  @override
  String toString() => 'KanbanBoard(columns: ${columns.keys}, totalTasks: ${allTasks.length})';
}
