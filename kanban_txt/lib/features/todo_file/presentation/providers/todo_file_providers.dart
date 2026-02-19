import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban_txt/shared/data/datasources/todo_file_datasource.dart';
import 'package:kanban_txt/features/todo_file/data/repositories/todo_file_repository_impl.dart';
import 'package:kanban_txt/features/todo_file/domain/repositories/todo_file_repository.dart';

/// Provide TodoFileRepository for file selection and I/O
final todoFileRepositoryProvider = Provider<TodoFileRepository>((ref) {
  final datasource = TodoFileDatasource();
  return TodoFileRepositoryImpl(datasource: datasource);
});
