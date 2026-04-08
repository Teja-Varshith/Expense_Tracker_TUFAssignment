import 'package:expense_tracker_tuf/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return HiveService.getThemeMode();
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
    HiveService.saveThemeMode(state);
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    HiveService.saveThemeMode(state);
  }

  bool get isDark => state == ThemeMode.dark;
}
