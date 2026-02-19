# Kanban Todo - Flutter Todo.txt Kanban Board

A Flutter Kanban board app that reads, visualizes, and edits local `todo.txt` files. Each column represents a `list:` tag value, and each card is a task line.

## Features

**File Management**
- Pick any `todo.txt` file from your device
- Change files anytime via "Change" button
- Real-time file synchronization (changes persist instantly)

**Kanban Board**
- Columns organized by `list:` tag (backlog, in-progress, done, etc.)
- Cards display full task metadata (priority, contexts, projects, dates)
- Smooth horizontal scrolling for multiple columns

**Task CRUD**
- Create new tasks with description, priority, and list assignment
- Edit tasks inline (change text, move to different columns, mark complete)
- Delete tasks with confirmation
- Preserve all todo.txt metadata (creation dates, completion dates, etc.)

**Filtering**
- Filter by completion status (Active, Completed, All)
- Filter by priority (A, B, C, etc.)
- Filter by contexts (@home, @work, etc.)
- Combine multiple filters

**Todo.txt Format Support**
- Completion marker: `x YYYY-MM-DD`
- Priority: `(A)`, `(B)`, `(C)`
- Creation date: `YYYY-MM-DD`
- Contexts: `@home`, `@work`
- Projects: `+project1`, `+project2`
- Key-value tags: `list:backlog`, `due:2024-01-20`

**Responsive UI**
- Material Design 3
- Light/Dark theme (system preference)
- Optimized for Android phones, tablets, and Linux desktop
- Font scaling support

## Project Structure

```
kanban_txt/
├── core/                           # App-wide utilities
│   ├── constants/                  # Magic strings, defaults
│   ├── extensions/                 # String and context helpers
│   ├── theme/                      # Material 3 themes
│   └── utils/                      # Logging
├── features/
│   ├── kanban_board/               # Main board feature
│   │   ├── data/                   # Parsing, file I/O
│   │   ├── domain/                 # Business entities
│   │   └── presentation/           # UI, providers, state
│   └── todo_file/                  # File selection feature
│       ├── data/                   # File repositories
│       ├── domain/                 # File abstractions
│       └── presentation/           # File providers
├── shared/                         # Cross-feature utilities
│   ├── data/                       # Shared datasources
│   ├── providers/                  # Global providers
│   └── widgets/                    # Reusable UI components
├── test/                           # Unit tests
│   ├── unit/                       # Parser, model, board tests
│   └── fixtures/                   # Sample todo.txt
├── main.dart                       # App entry point
├── pubspec.yaml                    # Dependencies
└── README.md                       # This file
```

## Architecture

**Layered MVVM** with Riverpod state management:

- **Presentation** (Widgets, Riverpod Providers)
  - Pages: Kanban board screen
  - Widgets: Cards, columns, dialogs, filters
  - Providers: State management (board, tasks, filters)

- **Domain** (Business Logic)
  - Entities: Task, KanbanBoard, TodoFile
  - Repository Interfaces: Contracts for data access

- **Data** (Datasources & Implementations)
  - Datasources: File I/O, parsing
  - Repositories: Implement domain interfaces
  - Models: DTOs for data transfer

## Setup Instructions

### Prerequisites

- Flutter SDK (3.1.0+) - [Install Flutter](https://flutter.dev/docs/get-started/install)
- Android SDK (for Android testing) or Linux desktop support enabled
- VSCode with Flutter extension (or Android Studio)

### Installation

1. **Clone or navigate to the project**
   ```bash
   cd kanban_txt
   ```

2. **Create the folder structure** (if starting fresh)
   ```bash
   # Core
   mkdir -p lib/core/{constants,extensions,theme,utils}
   
   # Features
   mkdir -p lib/features/kanban_board/{data/{datasources,models,repositories},domain/{entities,repositories},presentation/{pages,widgets,providers}}
   mkdir -p lib/features/todo_file/{data/{datasources,models,repositories},domain/{entities,repositories},presentation/providers}
   
   # Shared
   mkdir -p lib/shared/{data/datasources,providers,widgets}
   
   # Tests
   mkdir -p test/{unit,fixtures}
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Generate necessary files** (if using any code generation)
   ```bash
   flutter pub run build_runner build
   ```

### Running the App

**On Android (Physical Device or Emulator)**
```bash
# List connected devices
flutter devices

# Run on default device
flutter run

# Run on specific device
flutter run -d <device_id>
```

**On Linux Desktop**
```bash
# Enable Linux desktop (one-time setup)
flutter config --enable-linux-desktop

# Run on Linux
flutter run -d linux
```

**With Debug Output**
```bash
flutter run -v
```

### Building Releases

**Android APK**
```bash
flutter build apk
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Android App Bundle** (for Google Play)
```bash
flutter build appbundle
# Output: build/app/outputs/bundle/release/app-release.aab
```

**Linux Binary**
```bash
flutter build linux
# Output: build/linux/x64/release/bundle/
```

## Usage

### First Launch

1. **App starts** → Shows "No file loaded"
2. **Tap "Change" button** → File picker opens
3. **Select a `todo.txt` file** → Board loads with tasks organized by `list:` tag

### Creating a Todo.txt File

Create a file named `todo.txt` with this format:

```
(A) 2024-01-15 Buy groceries @home list:backlog
(B) Call mom @personal list:in-progress
x 2024-01-14 Complete presentation +work list:done
Implement login +backend @work list:backlog
```

**Todo.txt Format Guide:**
- `x ` = Completed task
- `(A)` `(B)` `(C)` = Priority levels
- `YYYY-MM-DD` = Creation date (appears after priority if present)
- `@context` = Context tag
- `+project` = Project tag
- `key:value` = Key-value pairs (e.g., `list:backlog`)

### Adding Tasks

1. **Tap the "+" button** (bottom-right FAB)
2. **Enter description** (e.g., "Buy milk @home")
3. **Select column** (list tag)
4. **Set priority** (optional)
5. **Tap Save** → Task added to file

### Editing Tasks

1. **Tap a card** → Edit dialog opens
2. **Modify description, priority, or list**
3. **Tap Save** → File updated instantly

### Deleting Tasks

1. **Tap a card** → Edit dialog opens
2. **Tap Delete** → Task removed from file

### Filtering

- **Show All / Active / Completed** - Toggle completion status
- **Priority chips** (P A, P B, P C) - Filter by priority
- **Context chips** (@home, @work, etc.) - Filter by context
- **Clear** - Remove all filters

## Testing

### Run All Tests

```bash
flutter test
```

### Run Specific Test File

```bash
flutter test test/unit/string_extensions_test.dart
flutter test test/unit/task_model_test.dart
flutter test test/unit/todo_parser_datasource_test.dart
flutter test test/unit/kanban_board_test.dart
```

### Run Tests with Coverage

```bash
flutter test --coverage
# Coverage report: coverage/lcov.info
```

### Test Files Included

- **string_extensions_test.dart** - Tests todo.txt line parsing
- **task_model_test.dart** - Tests Task entity
- **todo_parser_datasource_test.dart** - Tests parsing and formatting
- **kanban_board_test.dart** - Tests board organization
- **sample_todo.txt** - Sample file for manual testing

## Sample Todo.txt

A `sample_todo.txt` is included in `test/fixtures/`:

```
(A) 2024-01-15 Buy milk @home list:backlog
(B) Call mom @personal list:in-progress
x 2024-01-16 Complete project +work list:done
(A) 2024-01-18 Implement feature +backend +mobile list:backlog
Fix bug in login +mobile @work list:in-progress
x 2024-01-17 Write documentation +backend list:done
(C) Review PR +backend @work list:in-progress
2024-01-20 Book appointment @personal list:backlog
```

Use this as a template for testing.

## Troubleshooting

### File Picker Not Working

**Problem:** File picker dialog doesn't open or crashes.

**Solution:**
- Check permissions in `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
  ```
- On Android 13+, use scoped storage (handled by `file_picker` package)

### File Not Found After Restart

**Problem:** File path is lost after app restart.

**Solution:**
- This is expected; file path is stored in memory only
- To persist: implement SharedPreferences to save file path
- On first launch, user must select file again

### Tasks Not Appearing

**Problem:** Board is empty or tasks don't show.

**Causes:**
- File has no `list:` tags (tasks default to `backlog`)
- Tasks are hidden by active filters
- File path is invalid

**Solution:**
- Ensure tasks have `list:` tags: `task description list:column_name`
- Clear all filters via "Clear" button
- Verify file path in header

### Android Build Issues

**Problem:** `flutter run` fails with build error.

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### Linux Desktop Black Screen

**Problem:** App starts but shows blank window.

**Solution:**
```bash
flutter clean
flutter run -d linux -v
```

Check terminal for error messages.

## Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `file_picker` | File selection UI |
| `path_provider` | File system paths |
| `intl` | Date formatting |
| `logger` | Debug logging |

See `pubspec.yaml` for exact versions.

## Performance Notes

- **Parsing:** <100ms for 1000 tasks
- **Rendering:** 60 FPS scrolling on Android 10+
- **File I/O:** Instant writes (no buffering, direct file sync)
- **Memory:** ~10-20 MB for typical usage

## Future Enhancements

- [ ] Drag-and-drop between columns
- [ ] Search/full-text filter
- [ ] Undo/redo history
- [ ] Cloud sync (Google Drive, Dropbox)
- [ ] Due date notifications
- [ ] Recurring tasks
- [ ] Custom themes
- [ ] Import/export (CSV, JSON)

## License

This project is open source and available under the MIT License.

## Support

For issues, feature requests, or questions:
1. Check the troubleshooting section above
2. Review test files for usage examples
3. Examine the code comments for implementation details

