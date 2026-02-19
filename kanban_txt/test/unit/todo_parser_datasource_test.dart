import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_txt/features/kanban_board/data/datasources/todo_parser_datasource.dart';
import 'package:kanban_txt/features/kanban_board/domain/entities/task.dart';

void main() {
  group('TodoParserDatasource', () {
    final datasource = TodoParserDatasource();

    test('Parse todo content with multiple tasks', () {
      const content = '''(A) 2024-01-15 Buy milk @home list:backlog
x 2024-01-16 Call mom @personal list:done
Implement feature +backend list:in-progress''';

      final tasks = datasource.parseTodoContent(content);

      expect(tasks.length, 3);
      expect(tasks[0].priority, 'A');
      expect(tasks[1].isCompleted, true);
      expect(tasks[2].listTag, 'in-progress');
    });

    test('Format task back to todo.txt line', () {
      final task = Task(
        id: 'task_1',
        originalLine: 'Original',
        isCompleted: false,
        priority: 'A',
        creationDate: DateTime(2024, 1, 15),
        completionDate: null,
        description: 'Buy milk @home',
        contexts: ['home'],
        projects: [],
        tags: {'list': 'backlog'},
        listTag: 'backlog',
      );

      final line = datasource.formatTaskToLine(task);

      expect(line, contains('(A)'));
      expect(line, contains('2024-01-15'));
      expect(line, contains('Buy milk @home'));
      expect(line, contains('list:backlog'));
    });

    test('Format completed task includes completion date', () {
      final task = Task(
        id: 'task_1',
        originalLine: 'Original',
        isCompleted: true,
        priority: null,
        creationDate: DateTime(2024, 1, 15),
        completionDate: DateTime(2024, 1, 20),
        description: 'Buy milk @home',
        contexts: ['home'],
        projects: [],
        tags: {'list': 'done'},
        listTag: 'done',
      );

      final line = datasource.formatTaskToLine(task);

      expect(line, startsWith('x'));
      expect(line, contains('2024-01-20'));
    });

    test('Build kanban board from tasks', () {
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
          listTag: 'in-progress',
        ),
        Task(
          id: 'task_3',
          originalLine: '',
          isCompleted: true,
          priority: null,
          creationDate: null,
          completionDate: null,
          description: 'Task 3',
          contexts: [],
          projects: [],
          tags: {},
          listTag: 'done',
        ),
      ];

      final board = datasource.buildKanbanBoard(tasks);

      expect(board.columnOrder.length, 3);
      expect(board.getColumn('backlog').length, 1);
      expect(board.getColumn('in-progress').length, 1);
      expect(board.getColumn('done').length, 1);
    });

    test('Handle empty content', () {
      const content = '';
      final tasks = datasource.parseTodoContent(content);

      expect(tasks, isEmpty);
    });

    test('Handle content with empty lines', () {
      const content = '''(A) Task 1 list:backlog

Task 2 list:in-progress

''';

      final tasks = datasource.parseTodoContent(content);

      expect(tasks.length, 2);
    });
  });
}
