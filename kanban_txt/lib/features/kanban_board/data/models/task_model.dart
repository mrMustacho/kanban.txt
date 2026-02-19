import 'package:kanban_txt/features/kanban_board/domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required String id,
    required String originalLine,
    required bool isCompleted,
    String? priority,
    DateTime? creationDate,
    DateTime? completionDate,
    required String description,
    required List<String> contexts,
    required List<String> projects,
    required Map<String, String> tags,
    required String listTag,
  }) : super(
    id: id,
    originalLine: originalLine,
    isCompleted: isCompleted,
    priority: priority,
    creationDate: creationDate,
    completionDate: completionDate,
    description: description,
    contexts: contexts,
    projects: projects,
    tags: tags,
    listTag: listTag,
  );

  /// Convert from Task to TaskModel
  factory TaskModel.fromTask(Task task) {
    return TaskModel(
      id: task.id,
      originalLine: task.originalLine,
      isCompleted: task.isCompleted,
      priority: task.priority,
      creationDate: task.creationDate,
      completionDate: task.completionDate,
      description: task.description,
      contexts: task.contexts,
      projects: task.projects,
      tags: task.tags,
      listTag: task.listTag,
    );
  }
}
