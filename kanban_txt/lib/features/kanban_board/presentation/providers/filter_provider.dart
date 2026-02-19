import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/task.dart';

/// Active filters state
final filterProvider = StateProvider<FilterState>((ref) => FilterState());

class FilterState {
  final Set<String> contexts; // @work, @home, etc.
  final Set<String> projects; // +project1, etc.
  final bool? showCompleted; // null = show all, true = only completed, false = only incomplete
  final String? priorityFilter; // A, B, C, or null

  FilterState({
    this.contexts = const {},
    this.projects = const {},
    this.showCompleted,
    this.priorityFilter,
  });

  FilterState copyWith({
    Set<String>? contexts,
    Set<String>? projects,
    bool? showCompleted,
    String? priorityFilter,
  }) {
    return FilterState(
      contexts: contexts ?? this.contexts,
      projects: projects ?? this.projects,
      showCompleted: showCompleted ?? this.showCompleted,
      priorityFilter: priorityFilter ?? this.priorityFilter,
    );
  }

  /// Check if a task matches current filters
  bool matches(Task task) {
    // Context filter
    if (contexts.isNotEmpty) {
      if (!task.contexts.any((c) => contexts.contains(c))) {
        return false;
      }
    }

    // Project filter
    if (projects.isNotEmpty) {
      if (!task.projects.any((p) => projects.contains(p))) {
        return false;
      }
    }

    // Completion filter
    if (showCompleted != null) {
      if (task.isCompleted != showCompleted) {
        return false;
      }
    }

    // Priority filter
    if (priorityFilter != null) {
      if (task.priority != priorityFilter) {
        return false;
      }
    }

    return true;
  }

  /// Check if any filters are active
  bool get isActive =>
      contexts.isNotEmpty ||
      projects.isNotEmpty ||
      showCompleted != null ||
      priorityFilter != null;

  /// Clear all filters
  FilterState clearAll() => FilterState();
}
