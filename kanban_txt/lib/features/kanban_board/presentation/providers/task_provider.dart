import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/task.dart';
import 'package:kanban_txt/features/kanban_board/presentation/providers/kanban_provider.dart';
import 'package:kanban_txt/features/kanban_board/presentation/providers/filter_provider.dart';
// import 'package:kanban_txt/features/kanban_board/presentation/providers/providers.dart';
import 'package:kanban_txt/shared/providers/providers.dart';
import 'package:kanban_txt/core/utils/logger.dart';

/// Provider for task CRUD operations and filtering
final taskServiceProvider = Provider((ref) => TaskService(ref));

class TaskService {
  final Ref ref;

  TaskService(this.ref);

  /// Get all tasks, optionally filtered
  Future<List<Task>> getAllTasks({bool applyFilter = true}) async {
    final board = await ref.watch(kanbanBoardWithRefreshProvider.future);
    if (board == null) return [];

    var tasks = board.allTasks;

    if (applyFilter) {
      final filter = ref.watch(filterProvider);
      tasks = tasks.where((t) => filter.matches(t)).toList();
    }

    return tasks;
  }

  /// Get tasks for a specific column
  Future<List<Task>> getColumnTasks(String listTag,
      {bool applyFilter = true}) async {
    final board = await ref.watch(kanbanBoardWithRefreshProvider.future);
    if (board == null) return [];

    var tasks = board.getColumn(listTag);

    if (applyFilter) {
      final filter = ref.watch(filterProvider);
      tasks = tasks.where((t) => filter.matches(t)).toList();
    }

    return tasks;
  }

  /// Update an existing task
  Future<void> updateTask(Task task) async {
    final filePath = ref.watch(currentFilePathProvider);
    if (filePath == null) return;

    try {
      final repository = ref.watch(kanbanRepositoryProvider);
      await repository.updateTask(filePath, task);
      _refreshBoard();
    } catch (e) {
      logger.e('Error updating task: $e');
      rethrow;
    }
  }

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    final filePath = ref.watch(currentFilePathProvider);
    if (filePath == null) return;

    try {
      final repository = ref.watch(kanbanRepositoryProvider);
      await repository.deleteTask(filePath, taskId);
      _refreshBoard();
    } catch (e) {
      logger.e('Error deleting task: $e');
      rethrow;
    }
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    final filePath = ref.watch(currentFilePathProvider);
    if (filePath == null) return;

    try {
      final repository = ref.watch(kanbanRepositoryProvider);
      await repository.addTask(filePath, task);
      _refreshBoard();
    } catch (e) {
      logger.e('Error adding task: $e');
      rethrow;
    }
  }

  /// Refresh the board
  void _refreshBoard() {
    ref.refresh(boardRefreshTriggerProvider);
  }
}

/// Get all distinct contexts from all tasks
final allContextsProvider = FutureProvider<Set<String>>((ref) async {
  final board = await ref.watch(kanbanBoardWithRefreshProvider.future);
  if (board == null) return {};

  final contexts = <String>{};
  for (final task in board.allTasks) {
    contexts.addAll(task.contexts);
  }
  return contexts;
});

/// Get all distinct projects from all tasks
final allProjectsProvider = FutureProvider<Set<String>>((ref) async {
  final board = await ref.watch(kanbanBoardWithRefreshProvider.future);
  if (board == null) return {};

  final projects = <String>{};
  for (final task in board.allTasks) {
    projects.addAll(task.projects);
  }
  return projects;
});

/// Get all distinct priorities from all tasks
final allPrioritiesProvider = FutureProvider<Set<String>>((ref) async {
  final board = await ref.watch(kanbanBoardWithRefreshProvider.future);
  if (board == null) return {};

  final priorities = <String>{};
  for (final task in board.allTasks) {
    if (task.priority != null) {
      priorities.add(task.priority!);
    }
  }
  return priorities;
});
