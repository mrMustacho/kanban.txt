import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/kanban_board.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/task.dart';
// import 'package:kanban_txt/features/kanban_board/presentation/providers/providers.dart';
import 'package:kanban_txt/shared/providers/providers.dart';

/// Current file path being edited
final currentFilePathProvider = StateProvider<String?>((ref) => null);

/// Kanban board state (async)
final kanbanBoardProvider = FutureProvider<KanbanBoard?>((ref) async {
  final filePath = ref.watch(currentFilePathProvider);
  if (filePath == null) return null;

  final repository = ref.watch(kanbanRepositoryProvider);
  return repository.loadBoard(filePath);
});

/// Refresh the board (manual trigger)
final boardRefreshTriggerProvider = StateProvider<int>((ref) => 0);

/// Kanban board with refresh capability
final kanbanBoardWithRefreshProvider =
    FutureProvider<KanbanBoard?>((ref) async {
  ref.watch(boardRefreshTriggerProvider); // Trigger refresh
  final filePath = ref.watch(currentFilePathProvider);
  if (filePath == null) return null;

  final repository = ref.watch(kanbanRepositoryProvider);
  return repository.loadBoard(filePath);
});

/// Get a single task by ID
final taskByIdProvider =
    FutureProvider.family<Task?, String>((ref, taskId) async {
  final board = await ref.watch(kanbanBoardWithRefreshProvider.future);
  if (board == null) return null;

  for (final task in board.allTasks) {
    if (task.id == taskId) return task;
  }
  return null;
});
