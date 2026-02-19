import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban_txt/features/kanban_board/presentation/providers/task_provider.dart';
import 'package:kanban_txt/features/kanban_board/presentation/providers/filter_provider.dart';
import 'package:kanban_txt/core/constants/app_constants.dart';

/// Filter bar showing active filters and filter controls
class FilterBar extends ConsumerWidget {
  const FilterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingSmall),
        child: Row(
          children: [
            // Completion filter
            FilterChip(
              label: const Text('Show All'),
              selected: filter.showCompleted == null,
              onSelected: (_) {
                ref.read(filterProvider.notifier).state = filter.copyWith(showCompleted: null);
              },
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            FilterChip(
              label: const Text('Active'),
              selected: filter.showCompleted == false,
              onSelected: (_) {
                ref.read(filterProvider.notifier).state = filter.copyWith(showCompleted: false);
              },
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            FilterChip(
              label: const Text('Completed'),
              selected: filter.showCompleted == true,
              onSelected: (_) {
                ref.read(filterProvider.notifier).state = filter.copyWith(showCompleted: true);
              },
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Divider(
              thickness: 1,
            ),
            const SizedBox(width: AppConstants.paddingMedium),

            // Priority filters
            _buildPriorityFilters(context, ref, filter),

            // Context filters
            _buildContextFilters(context, ref, filter),

            // Clear all button
            if (filter.isActive)
              TextButton.icon(
                onPressed: () {
                  ref.read(filterProvider.notifier).state = filter.clearAll();
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityFilters(
    BuildContext context,
    WidgetRef ref,
    FilterState filter,
  ) {
    final prioritiesAsync = ref.watch(allPrioritiesProvider);

    return prioritiesAsync.when(
      data: (priorities) {
        if (priorities.isEmpty) return const SizedBox.shrink();

        return Row(
          children: priorities
              .map((p) => Padding(
                    padding: const EdgeInsets.only(right: AppConstants.paddingSmall),
                    child: FilterChip(
                      label: Text('P$p'),
                      selected: filter.priorityFilter == p,
                      onSelected: (_) {
                        ref.read(filterProvider.notifier).state =
                            filter.copyWith(priorityFilter: filter.priorityFilter == p ? null : p);
                      },
                    ),
                  ))
              .toList(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
    );
  }

  Widget _buildContextFilters(
    BuildContext context,
    WidgetRef ref,
    FilterState filter,
  ) {
    final contextsAsync = ref.watch(allContextsProvider);

    return contextsAsync.when(
      data: (contexts) {
        if (contexts.isEmpty) return const SizedBox.shrink();

        return Row(
          children: contexts
              .take(5)
              .map((c) => Padding(
                    padding: const EdgeInsets.only(right: AppConstants.paddingSmall),
                    child: FilterChip(
                      label: Text('@$c'),
                      selected: filter.contexts.contains(c),
                      onSelected: (_) {
                        final updated = {...filter.contexts};
                        if (updated.contains(c)) {
                          updated.remove(c);
                        } else {
                          updated.add(c);
                        }
                        ref.read(filterProvider.notifier).state =
                            filter.copyWith(contexts: updated);
                      },
                    ),
                  ))
              .toList(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
    );
  }
}
