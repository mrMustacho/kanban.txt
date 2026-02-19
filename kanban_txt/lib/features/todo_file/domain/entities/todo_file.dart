class TodoFile {
  final String filePath;
  final String rawContent;

  TodoFile({
    required this.filePath,
    required this.rawContent,
  });

  @override
  String toString() => 'TodoFile(path: $filePath, lines: ${rawContent.split('\n').length})';
}
