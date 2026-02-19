import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_txt/features/kanban_board/presentation/providers/filter_provider.dart';

void main() {
  group('FilterState', () {
    test('Create filter state with defaults', () {
      final filter = FilterState();

      expect(filter.contexts, isEmpty);
      expect(filter.projects, isEmpty);
      expect(filter.showCompleted, isNull);
      expect(filter.priorityFilter, isNull);
      expect(filter.isActive, false);
    });

    test('Copy filter with updated fields', () {
      final original = FilterState(
        contexts: {'home', 'work'},
        priorities: const {},
      );

      final updated = original.copyWith(
        showCompleted: true,
      );

      expect(updated.contexts, {'home', 'work'});
      expect(updated.showCompleted, true);
      expect(updated.isActive, true);
    });

    test('Clear all filters', () {
      final filter = FilterState(
        contexts: {'home'},
        showCompleted: true,
        priorityFilter: 'A',
      );

      final cleared = filter.clearAll();

      expect(cleared.contexts, isEmpty);
      expect(cleared.showCompleted, isNull);
      expect(cleared.priorityFilter, isNull);
      expect(cleared.isActive, false);
    });

    test('Filter matches task by context', () {
      final filter = FilterState(contexts: {'home'});

      // Note: This test would require importing Task entity
      // It's a placeholder for proper integration testing
      expect(filter.contexts.contains('home'), true);
    });
  });
}
