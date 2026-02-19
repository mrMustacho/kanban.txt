import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/kanban_board.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/task.dart';

void main() {
  group('KanbanBoard', () {
    test('Get all tasks from all columns', () {
      final backlogTasks = [
        Task(
          id: 'task_1',
          originalLine: '',
          isCompleted: false,
          priority: null,
          creationDate: null,
          completionDate: null,
          description: 'Task 1',
          contexts: [],
          projects: [],
          tags: {},
          listTag: 'backlog',
        ),
      ];

      final inProgressTasks = [
        Task(
          id: 'task_2',
          originalLine: '',
          isCompleted: false,
          priority: null,
          creationDate: null,
          completionDate: null,
          description: 'Task 2',
          contexts: [],
          projects: [],
          tags: {},
          listTag: 'in-progress',
        ),
      ];

      final board = KanbanBoard(
        columns: {
          'backlog': backlogTasks,
          'in-progress': inProgressTasks,
        },
        columnOrder: ['backlog', 'in-progress'],
      );

      expect(board.allTasks.length, 2);
      expect(board.allTasks.map((t) => t.id).toList(), ['task_1', 'task_2']);
    });

    test('Get specific column tasks', () {
      final tasks = [
        Task(
          id: 'task_1',
          originalLine: '',
          isCompleted: false,
          priority: null,
          creationDate: null,
          completionDate: null,
          description: 'Task 1',
          contexts: [],
          projects: [],
          tags: {},
          listTag: 'backlog',
        ),
        Task(
          id: 'task_2',
          originalLine: '',
          isCompleted: false,
          priority: null,
          creationDate: null,
          completionDate: null,
          description: 'Task 2',
          contexts: [],
          projects: [],
          tags: {},
          listTag: 'backlog',
        ),
      ];

      final board = KanbanBoard(
        columns: {'backlog': tasks},
        columnOrder: ['backlog'],
      );

      expect(board.getColumn('backlog').length, 2);
      expect(board.getColumn('done'), isEmpty);
    });

    test('Empty board returns empty lists', () {
      final board = KanbanBoard(
        columns: {},
        columnOrder: [],
      );

      expect(board.allTasks, isEmpty);
      expect(board.getColumn('any'), isEmpty);
    });
  });
}
