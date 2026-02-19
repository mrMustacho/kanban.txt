import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/task.dart';

void main() {
  group('TaskModel', () {
    test('Task creation with all fields', () {
      final task = Task(
        id: 'task_1',
        originalLine: '(A) 2024-01-15 Buy milk @home list:backlog',
        isCompleted: false,
        priority: 'A',
        creationDate: DateTime(2024, 1, 15),
        completionDate: null,
        description: 'Buy milk @home list:backlog',
        contexts: ['home'],
        projects: [],
        tags: {'list': 'backlog'},
        listTag: 'backlog',
      );

      expect(task.id, 'task_1');
      expect(task.priority, 'A');
      expect(task.isCompleted, false);
      expect(task.listTag, 'backlog');
      expect(task.contexts, ['home']);
    });

    test('Task copyWith updates specific fields', () {
      final original = Task(
        id: 'task_1',
        originalLine: 'Original line',
        isCompleted: false,
        priority: 'A',
        creationDate: DateTime(2024, 1, 15),
        completionDate: null,
        description: 'Original description',
        contexts: ['home'],
        projects: ['project1'],
        tags: {'list': 'backlog'},
        listTag: 'backlog',
      );

      final updated = original.copyWith(
        isCompleted: true,
        listTag: 'done',
        description: 'Updated description',
      );

      expect(updated.isCompleted, true);
      expect(updated.listTag, 'done');
      expect(updated.description, 'Updated description');
      expect(updated.priority, 'A'); // Unchanged
      expect(updated.contexts, ['home']); // Unchanged
    });

    test('Task completion mark changes when completed', () {
      final task = Task(
        id: 'task_1',
        originalLine: 'Buy milk @home',
        isCompleted: false,
        priority: null,
        creationDate: null,
        completionDate: null,
        description: 'Buy milk @home',
        contexts: ['home'],
        projects: [],
        tags: {},
        listTag: 'backlog',
      );

      final completed = task.copyWith(
        isCompleted: true,
        completionDate: DateTime.now(),
      );

      expect(completed.isCompleted, true);
      expect(completed.completionDate, isNotNull);
    });
  });
}
