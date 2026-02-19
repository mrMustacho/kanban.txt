import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:kanban_txt/core/utils/logger.dart';

/// Datasource for todo.txt file I/O operations
class TodoFileDatasource {
  /// Allow user to pick a todo.txt file from the file system
  Future<String?> pickTodoFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
        dialogTitle: 'Select todo.txt file',
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files.first.path;
      }
      return null;
    } catch (e) {
      logger.e('Error picking file: $e');
      return null;
    }
  }

  /// Read file content
  Future<String> readFile(String filePath) async {
    try {
      final file = File(filePath);
      return await file.readAsString();
    } catch (e) {
      logger.e('Error reading file: $e');
      rethrow;
    }
  }

  /// Write content to file
  Future<void> writeFile(String filePath, String content) async {
    try {
      final file = File(filePath);
      await file.writeAsString(content);
    } catch (e) {
      logger.e('Error writing file: $e');
      rethrow;
    }
  }

  /// Check if file exists
  Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      logger.e('Error checking file: $e');
      return false;
    }
  }
}
