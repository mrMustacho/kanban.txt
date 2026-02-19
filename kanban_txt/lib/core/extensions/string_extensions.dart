extension StringExtensions on String {
  /// Parse a todo.txt line into components.
  /// Returns a map with keys: completion, priority, creationDate, text, metadata
  Map<String, dynamic> parseTodoLine() {
    String remaining = trim();
    bool isCompleted = false;
    String? priority;
    DateTime? creationDate;

    // Check for completion marker: "x " at start
    if (remaining.startsWith('x ')) {
      isCompleted = true;
      remaining = remaining.substring(2).trim();
    }

    // Check for priority: "(A) " format
    final priorityRegex = RegExp(r'^\([A-Z]\) ');
    if (priorityRegex.hasMatch(remaining)) {
      priority = remaining[1]; // Get the letter between parens
      remaining = remaining.substring(4).trim();
    }

    // If completed, there might be a completion date after priority
    DateTime? completionDate;
    if (isCompleted && remaining.length >= 11) {
      final dateMatch = RegExp(r'^\d{4}-\d{2}-\d{2}').firstMatch(remaining);
      if (dateMatch != null) {
        try {
          completionDate = DateTime.parse(dateMatch.group(0)!);
          remaining = remaining.substring(10).trim();
        } catch (e) {
          // Not a valid date, continue
        }
      }
    }

    // Check for creation date: "YYYY-MM-DD " format (if not completed)
    if (!isCompleted && remaining.length >= 11) {
      final dateMatch = RegExp(r'^\d{4}-\d{2}-\d{2}').firstMatch(remaining);
      if (dateMatch != null) {
        try {
          creationDate = DateTime.parse(dateMatch.group(0)!);
          remaining = remaining.substring(10).trim();
        } catch (e) {
          // Not a valid date, continue
        }
      }
    }

    return {
      'isCompleted': isCompleted,
      'priority': priority,
      'creationDate': creationDate,
      'completionDate': completionDate,
      'text': remaining,
    };
  }

  /// Extract all contexts (@tag) from a string
  List<String> extractContexts() {
    final regex = RegExp(r'@(\w+)');
    return regex.allMatches(this).map((m) => m.group(1)!).toList();
  }

  /// Extract all projects (+tag) from a string
  List<String> extractProjects() {
    final regex = RegExp(r'\+(\w+)');
    return regex.allMatches(this).map((m) => m.group(1)!).toList();
  }

  /// Extract key:value pairs from a string
  Map<String, String> extractKeyValues() {
    final regex = RegExp(r'(\w+):(\S+)');
    final result = <String, String>{};
    for (final match in regex.allMatches(this)) {
      result[match.group(1)!] = match.group(2)!;
    }
    return result;
  }
}
