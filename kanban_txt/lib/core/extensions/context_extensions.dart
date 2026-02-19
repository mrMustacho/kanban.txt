import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  /// Get the current theme's color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get the current theme's text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Check if device is in dark mode
  bool get isDarkMode => MediaQuery.of(this).platformBrightness == Brightness.dark;
}
