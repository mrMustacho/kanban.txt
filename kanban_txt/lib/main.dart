import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/kanban_board/presentation/pages/kanban_board_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: KanbanTxtApp(),
    ),
  );
}

class KanbanTxtApp extends StatelessWidget {
  const KanbanTxtApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kanban Todo',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const KanbanBoardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
