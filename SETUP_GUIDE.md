# Kanban Todo - Complete Setup Guide

## Quick Start (TL;DR)

```bash
# 1. Navigate to project
cd kanban_txt

# 2. Get dependencies
flutter pub get

# 3. Run on device
flutter run

# 4. Run tests
flutter test
```

---

## Detailed Setup Steps

### Step 1: Project Structure Verification

Verify your folder structure matches:

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── extensions/
│   │   ├── context_extensions.dart
│   │   └── string_extensions.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── logger.dart
├── features/
│   ├── kanban_board/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── todo_parser_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── task_model.dart
│   │   │   └── repositories/
│   │   │       └── kanban_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── kanban_board.dart
│   │   │   │   └── task.dart
│   │   │   └── repositories/
│   │   │       └── kanban_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── kanban_board_page.dart
│   │       ├── providers/
│   │       │   ├── filter_provider.dart
│   │       │   ├── kanban_provider.dart
│   │       │   └── task_provider.dart
│   │       └── widgets/
│   │           ├── file_info_header.dart
│   │           ├── filter_bar.dart
│   │           ├── kanban_board_widget.dart
│   │           ├── kanban_column.dart
│   │           ├── task_card.dart
│   │           └── task_edit_dialog.dart
│   └── todo_file/
│       ├── data/
│       │   ├── datasources/ (empty - uses shared)
│       │   ├── models/
│       │   │   └── task_model.dart
│       │   └── repositories/
│       │       └── todo_file_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── todo_file.dart
│       │   └── repositories/
│       │       └── todo_file_repository.dart
│       └── presentation/
│           └── providers/
│               └── todo_file_providers.dart
├── shared/
│   ├── data/
│   │   └── datasources/
│   │       └── todo_file_datasource.dart
│   ├── providers/
│   │   └── providers.dart
│   └── widgets/
│       └── loading_overlay.dart
├── main.dart
└── pubspec.yaml

test/
├── unit/
│   ├── filter_provider_test.dart
│   ├── kanban_board_test.dart
│   ├── string_extensions_test.dart
│   ├── task_model_test.dart
│   └── todo_parser_datasource_test.dart
└── fixtures/
    └── sample_todo.txt
```

### Step 2: Install Flutter SDK

**Mac/Linux:**
```bash
# Download Flutter
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

**Windows:**
- Download from https://flutter.dev/docs/get-started/install/windows
- Extract and add to PATH
- Run `flutter doctor` in PowerShell

### Step 3: Get Project Dependencies

```bash
cd kanban_txt
flutter pub get
```

Expected output:
```
Running "flutter pub get" in kanban_txt...
[list of packages downloaded]
✓ Resolving dependencies...
✓ Getting packages...
✓ Precompiling executables...
[success message]
```

### Step 4: Setup Android (if targeting Android)

**Requirements:**
- Android SDK API level 21+
- Gradle

**Steps:**
```bash
# Check Android setup
flutter doctor -v

# If needed, accept licenses
flutter doctor --android-licenses

# Check connected devices
flutter devices
```

**Enable file permissions** in `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.kanban_txt">

    <!-- Add these permissions -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />

    <application
        android:label="@string/app_name"
        android:icon="@mipmap/ic_launcher">
        ...
    </application>
</manifest>
```

### Step 5: Setup Linux Desktop (Optional)

**Requirements:**
- GTK 3.0+
- GLib 2.12+

**First-time setup:**
```bash
flutter config --enable-linux-desktop
flutter doctor -v
```

### Step 6: Run the App

**On Android:**
```bash
# List devices
flutter devices

# Run (auto-detects device)
flutter run

# Run with verbose output
flutter run -v

# Run on specific device
flutter run -d emulator-5554
```

**On Linux Desktop:**
```bash
flutter run -d linux
```

**Hot Reload:**
- Press `r` to hot reload during development
- Press `R` to hot restart
- Press `q` to quit

### Step 7: Run Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/string_extensions_test.dart

# Run with coverage
flutter test --coverage

# View coverage (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
```

---

## Building for Release

### Android APK (Debug Installation)

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Install on device
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Google Play)

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### Linux Desktop

```bash
flutter build linux --release
# Output: build/linux/x64/release/bundle/

# Run the built app
./build/linux/x64/release/bundle/kanban_txt
```

---

## Troubleshooting

### Issue: "Flutter not found" / Command not in PATH

**Solution:**
```bash
# Add to .bashrc or .zshrc
export PATH="$PATH:~/flutter/bin"

# Verify
flutter --version
```

### Issue: "CocoaPods not installed" (macOS)

**Solution:**
```bash
sudo gem install cocoapods
pod setup
```

### Issue: Android SDK not found

**Solution:**
```bash
flutter config --android-sdk /path/to/android/sdk
flutter doctor -v
```

### Issue: "Device not found"

**Solution:**
```bash
# List devices
flutter devices

# For emulator
emulator -list-avds
emulator -avd <emulator_name>

# For physical device
adb devices  # Check if device shows

# If not showing, restart adb
adb kill-server
adb start-server
```

### Issue: Build fails with "Gradle error"

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: File picker not opening on Android

**Solution:**
- Ensure permissions are in `AndroidManifest.xml`
- Test on Android 11+ (scoped storage)
- Check device file system permissions

### Issue: Hot reload not working

**Solution:**
```bash
# Hot restart instead
Press R in terminal

# Or full rebuild
flutter run
```

---

## Development Workflow

### Recommended Setup

**VSCode Extensions:**
- Flutter
- Dart
- Better Comments
- Rainbow Brackets

**VSCode settings.json:**
```json
{
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "Dart-Code.dart-code"
  },
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.allowAnalytics": false
}
```

### Code Style

```bash
# Format code
dart format lib/ test/

# Analyze code
dart analyze lib/

# Run linter
flutter analyze
```

### Common Commands

```bash
flutter clean              # Clean build artifacts
flutter pub get            # Get dependencies
flutter pub upgrade        # Upgrade dependencies
flutter pub outdated       # Check for updates
flutter pub cache clean    # Clear pub cache
flutter devices            # List connected devices
flutter logs              # View device logs
```

---

## Testing Strategy

### Unit Tests (Test Business Logic)

Located in `test/unit/`:

```bash
flutter test test/unit/string_extensions_test.dart
flutter test test/unit/task_model_test.dart
flutter test test/unit/todo_parser_datasource_test.dart
flutter test test/unit/kanban_board_test.dart
flutter test test/unit/filter_provider_test.dart
```

### Widget Tests (Test UI Components)

To add widget tests, create `test/widget/`:

```dart
testWidgets('TaskCard displays task info', (WidgetTester tester) async {
  // Implementation
});
```

### Integration Tests (Test Full Flows)

To add integration tests, create `test_driver/` or use `integration_test/`:

```bash
flutter test integration_test/app_test.dart
```

---

## Performance Optimization

### Disable Analytics

```bash
flutter config --no-analytics
dart --disable-analytics
```

### Profile App

```bash
flutter run --profile

# Analyze performance
flutter run --profile --trace-startup
```

### Build APK Size

```bash
flutter build apk --analyze-size
flutter build appbundle --analyze-size
```

---

## Version Management

### Update Flutter

```bash
flutter upgrade
flutter channel stable  # or beta, dev, master
```

### Check Versions

```bash
flutter --version
dart --version
flutter doctor -v
```

---

## Next Steps

1. Copy all generated files to their locations
2. Run `flutter pub get`
3. Connect a device/emulator
4. Run `flutter run`
5. Test the app with `sample_todo.txt`
6. Run unit tests: `flutter test`
7. Deploy to Android/Linux!

---

## Support Resources

- **Official Docs:** https://flutter.dev/docs
- **Todo.txt Format:** http://todotxt.org/
- **Riverpod Guide:** https://riverpod.dev/
- **Material Design 3:** https://m3.material.io/
