import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
   return ThemeNotifier();
});

class ThemeNotifier extends Notifier<ThemeMode> {
  
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  void setTheme(ThemeMode mode) {
    state = mode;
  }

}