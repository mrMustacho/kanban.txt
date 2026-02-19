import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_txt/core/extensions/string_extensions.dart';

void main() {
  group('TodoLineParser', () {
    test('Parse simple task', () {
      const line = 'Buy milk @home';
      final parsed = line.parseTodoLine();

      expect(parsed['isCompleted'], false);
      expect(parsed['priority'], null);
      expect(parsed['text'], 'Buy milk @home');
    });

    test('Parse completed task', () {
      const line = 'x 2024-01-15 Buy milk @home';
      final parsed = line.parseTodoLine();

      expect(parsed['isCompleted'], true);
      expect(parsed['completionDate'], isNotNull);
      expect(parsed['text'], 'Buy milk @home');
    });

    test('Parse task with priority', () {
      const line = '(A) Buy milk @home';
      final parsed = line.parseTodoLine();

      expect(parsed['priority'], 'A');
      expect(parsed['text'], 'Buy milk @home');
    });

    test('Parse task with creation date', () {
      const line = '2024-01-10 Buy milk @home';
      final parsed = line.parseTodoLine();

      expect(parsed['creationDate'], isNotNull);
      expect(parsed['text'], 'Buy milk @home');
    });

    test('Parse task with priority and creation date', () {
      const line = '(B) 2024-01-10 Buy milk +groceries @home';
      final parsed = line.parseTodoLine();

      expect(parsed['priority'], 'B');
      expect(parsed['creationDate'], isNotNull);
      expect(parsed['text'], 'Buy milk +groceries @home');
    });

    test('Extract contexts', () {
      const text = 'Buy milk @home and call @work';
      final contexts = text.extractContexts();

      expect(contexts, ['home', 'work']);
    });

    test('Extract projects', () {
      const text = 'Implement feature +mobile for +backend';
      final projects = text.extractProjects();

      expect(projects, ['mobile', 'backend']);
    });

    test('Extract key-value pairs', () {
      const text = 'Task due:2024-01-20 list:backlog priority:high';
      final tags = text.extractKeyValues();

      expect(tags['due'], '2024-01-20');
      expect(tags['list'], 'backlog');
      expect(tags['priority'], 'high');
    });
  });
}
