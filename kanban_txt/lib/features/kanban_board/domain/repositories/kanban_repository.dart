import 'package:kanban_txt/features/kanban_board/domain/entities/kanban_board.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/task.dart';

abstract class KanbanRepository {
  /// Load and parse a todo.txt file into a KanbanBoard
  Future<KanbanBoard> loadBoard(String filePath);

  /// Save a modified task back to the file
  Future<void> updateTask(String filePath, Task task);

  /// Delete a task from the file
  Future<void> deleteTask(String filePath, String taskId);

  /// Add a new task to the file
  Future<void> addTask(String filePath, Task task);

  /// Get raw file content
  Future<String> getFileContent(String filePath);
}
