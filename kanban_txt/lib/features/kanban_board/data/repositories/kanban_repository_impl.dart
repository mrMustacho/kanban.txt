import 'package:kanban_txt/shared/data/datasources/todo_file_datasource.dart';
import 'package:kanban_txt/features/kanban_board/data/datasources/todo_parser_datasource.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/kanban_board.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/task.dart';
import 'package:kanban_txt/features/kanban_board/domain/repositories/kanban_repository.dart';
import 'package:kanban_txt/core/utils/logger.dart';

/// Implementation of KanbanRepository
class KanbanRepositoryImpl implements KanbanRepository {
  final TodoFileDatasource todoFileDatasource;
  final TodoParserDatasource todoParserDatasource;

  KanbanRepositoryImpl({
    required this.todoFileDatasource,
    required this.todoParserDatasource,
  });

  @override
  Future<KanbanBoard> loadBoard(String filePath) async {
    logger.i('Loading board from: $filePath');

    final content = await todoFileDatasource.readFile(filePath);
    final tasks = todoParserDatasource.parseTodoContent(content);
    final board = todoParserDatasource.buildKanbanBoard(tasks);

    logger.i('Loaded ${tasks.length} tasks');
    return board;
  }

  @override
  Future<void> updateTask(String filePath, Task task) async {
    logger.i('Updating task: ${task.id}');

    final currentContent = await todoFileDatasource.readFile(filePath);
    final lines = currentContent.split('\n');

    // Parse current tasks to find the one to update
    final allTasks = todoParserDatasource.parseTodoContent(currentContent);
    final taskIndex = allTasks.indexWhere((t) => t.id == task.id);

    if (taskIndex == -1) {
      logger.w('Task not found: ${task.id}');
      return;
    }

    // Format the updated task line
    final newLine = todoParserDatasource.formatTaskToLine(task);

    // Find actual line number in file (accounting for empty lines)
    int fileLineIndex = 0;
    int taskCount = 0;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].trim().isEmpty) continue;
      if (taskCount == taskIndex) {
        fileLineIndex = i;
        break;
      }
      taskCount++;
    }

    lines[fileLineIndex] = newLine;
    final updatedContent = lines.join('\n');
    await todoFileDatasource.writeFile(filePath, updatedContent);

    logger.i('Task updated successfully');
  }

  @override
  Future<void> deleteTask(String filePath, String taskId) async {
    logger.i('Deleting task: $taskId');

    final currentContent = await todoFileDatasource.readFile(filePath);
    final lines = currentContent.split('\n');

    // Parse current tasks to find the one to delete
    final allTasks = todoParserDatasource.parseTodoContent(currentContent);
    final taskIndex = allTasks.indexWhere((t) => t.id == taskId);

    if (taskIndex == -1) {
      logger.w('Task not found: $taskId');
      return;
    }

    // Find actual line number in file
    int fileLineIndex = 0;
    int taskCount = 0;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].trim().isEmpty) continue;
      if (taskCount == taskIndex) {
        fileLineIndex = i;
        break;
      }
      taskCount++;
    }

    lines.removeAt(fileLineIndex);
    final updatedContent = lines.join('\n');
    await todoFileDatasource.writeFile(filePath, updatedContent);

    logger.i('Task deleted successfully');
  }

  @override
  Future<void> addTask(String filePath, Task task) async {
    logger.i('Adding new task: ${task.description}');

    final currentContent = await todoFileDatasource.readFile(filePath);
    final newLine = todoParserDatasource.formatTaskToLine(task);

    final updatedContent =
        currentContent.isEmpty ? newLine : '$currentContent\n$newLine';

    await todoFileDatasource.writeFile(filePath, updatedContent);
    logger.i('Task added successfully');
  }

  @override
  Future<String> getFileContent(String filePath) async {
    return await todoFileDatasource.readFile(filePath);
  }
}
