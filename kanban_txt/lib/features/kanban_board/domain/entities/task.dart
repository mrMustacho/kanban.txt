class Task {
  final String id; // Unique ID (hash of line index + content)
  final String originalLine; // Raw line from file (for reconstruction)
  final bool isCompleted;
  final String? priority; // A, B, C, etc. or null
  final DateTime? creationDate;
  final DateTime? completionDate;
  final String description; // Main text
  final List<String> contexts; // @work, @home, etc.
  final List<String> projects; // +project1, etc.
  final Map<String, String> tags; // key:value pairs (excluding 'list')
  final String listTag; // The 'list:' value (determines column)

  Task({
    required this.id,
    required this.originalLine,
    required this.isCompleted,
    this.priority,
    this.creationDate,
    this.completionDate,
    required this.description,
    required this.contexts,
    required this.projects,
    required this.tags,
    required this.listTag,
  });

  /// Create a modified copy with updated fields
  Task copyWith({
    String? id,
    String? originalLine,
    bool? isCompleted,
    String? priority,
    DateTime? creationDate,
    DateTime? completionDate,
    String? description,
    List<String>? contexts,
    List<String>? projects,
    Map<String, String>? tags,
    String? listTag,
  }) {
    return Task(
      id: id ?? this.id,
      originalLine: originalLine ?? this.originalLine,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      creationDate: creationDate ?? this.creationDate,
      completionDate: completionDate ?? this.completionDate,
      description: description ?? this.description,
      contexts: contexts ?? this.contexts,
      projects: projects ?? this.projects,
      tags: tags ?? this.tags,
      listTag: listTag ?? this.listTag,
    );
  }

  @override
  String toString() =>
      'Task(id: $id, completed: $isCompleted, priority: $priority, list: $listTag, desc: $description)';
}
