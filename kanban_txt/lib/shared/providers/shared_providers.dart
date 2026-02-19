import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban_txt/features/kanban_board/data/datasources/todo_parser_datasource.dart';
import 'package:kanban_txt/features/kanban_board/data/repositories/kanban_repository_impl.dart';
import 'package:kanban_txt/features/kanban_board/domain/repositories/kanban_repository.dart';
import 'package:kanban_txt/features/todo_file/data/repositories/todo_file_repository_impl.dart';
import 'package:kanban_txt/features/todo_file/domain/repositories/todo_file_repository.dart';
import 'package:kanban_txt/shared/data/datasources/todo_file_datasource.dart';

/// Provide TodoParserDatasource
final todoParserProvider = Provider((ref) => TodoParserDatasource());

/// Provide TodoFileDatasource (shared)
final todoFileDatasourceProvider = Provider((ref) => TodoFileDatasource());

/// Provide TodoFileRepository
final todoFileRepositoryProvider = Provider<TodoFileRepository>((ref) {
  final datasource = ref.watch(todoFileDatasourceProvider);
  return TodoFileRepositoryImpl(datasource: datasource);
});

/// Provide KanbanRepository
final kanbanRepositoryProvider = Provider<KanbanRepository>((ref) {
  final fileDatasource = ref.watch(todoFileDatasourceProvider);
  final parserDatasource = ref.watch(todoParserProvider);
  return KanbanRepositoryImpl(
    todoFileDatasource: fileDatasource,
    todoParserDatasource: parserDatasource,
  );
});
