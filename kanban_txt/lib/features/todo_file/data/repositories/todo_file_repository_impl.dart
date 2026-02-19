import 'dart:io';
import 'package:kanban_txt/features/todo_file/domain/repositories/todo_file_repository.dart';
import 'package:kanban_txt/shared/data/datasources/todo_file_datasource.dart';

/// Implementation of TodoFileRepository
class TodoFileRepositoryImpl implements TodoFileRepository {
  final TodoFileDatasource datasource;

  TodoFileRepositoryImpl({required this.datasource});

  @override
  Future<String?> selectFile() => datasource.pickTodoFile();

  @override
  Future<bool> fileExists(String filePath) => datasource.fileExists(filePath);

  @override
  Future<String> readFile(String filePath) => datasource.readFile(filePath);

  @override
  Future<void> writeFile(String filePath, String content) =>
      datasource.writeFile(filePath, content);
}
