abstract class TodoFileRepository {
  /// Select a todo.txt file from the file system
  Future<String?> selectFile();

  /// Check if a file exists at the given path
  Future<bool> fileExists(String filePath);

  /// Read file content as string
  Future<String> readFile(String filePath);

  /// Write content to file
  Future<void> writeFile(String filePath, String content);
}
