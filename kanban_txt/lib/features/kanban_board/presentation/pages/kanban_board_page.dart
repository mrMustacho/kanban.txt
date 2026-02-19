import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban_txt/features/kanban_board/presentation/widgets/file_info_header.dart';
import 'package:kanban_txt/features/kanban_board/presentation/widgets/file_picker_dialog.dart';
import 'package:kanban_txt/features/kanban_board/presentation/widgets/filter_bar.dart';
import 'package:kanban_txt/features/kanban_board/presentation/widgets/kanban_board_widget.dart';
import 'package:kanban_txt/features/kanban_board/presentation/widgets/task_edit_dialog.dart';

/// Main Kanban Board Page
class KanbanBoardPage extends ConsumerWidget {
  const KanbanBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppBar(
          title: const Text('Kanban Todo'),
          elevation: 0,
        ),
        body: const Column(
          children: [
            // File info and change button
            FileInfoHeader(),
            // Filter bar
            FilterBar(),
            // Kanban board
            Expanded(
              child: KanbanBoardWidget(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addNewTask(context, ref),
          tooltip: 'Add new task',
          child: const Icon(Icons.add),
        ),
      );

  void _addNewTask(BuildContext context, WidgetRef ref) {
    // Open new task dialog
    showDialog(
      context: context,
      builder: (context) => TaskEditDialog.create(
        onSave: (description, listTag) async {
          // Implementation in TaskEditDialog
        },
      ),
    );
  }
}
