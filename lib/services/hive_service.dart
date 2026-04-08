import 'package:expense_tracker_tuf/models/transaction_model.dart';
import 'package:expense_tracker_tuf/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


// Central local storage service used by repositories.
class HiveService {
  HiveService._();

  static const String _txBox = 'transactions';
  static const String _userBox = 'user';
  static const String _settingsBox = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_txBox);
    await Hive.openBox(_userBox);
    await Hive.openBox(_settingsBox);
  }

  static Future<void> addTransaction(TransactionModel tx) async {
    final box = Hive.box(_txBox);
    await box.put(tx.id, tx.toMap());
  }

  static Future<void> updateTransaction(TransactionModel tx) async {
    final box = Hive.box(_txBox);
    await box.put(tx.id, tx.toMap());
  }

  static Future<void> deleteTransaction(String id) async {
    final box = Hive.box(_txBox);
    await box.delete(id);
  }

  static List<TransactionModel> getAllTransactions() {
    final box = Hive.box(_txBox);
    return box.values.map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      return TransactionModel.fromMap(map);
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static List<TransactionModel> getTransactionsByMonth(int year, int month) {
    return getAllTransactions()
        .where((tx) => tx.date.year == year && tx.date.month == month)
        .toList();
  }

  static Future<void> saveUser(AppUser user) async {
    final box = Hive.box(_userBox);
    await box.put('current_user', user.toMap());
  }

  static AppUser? getUser() {
    final box = Hive.box(_userBox);
    final data = box.get('current_user');
    if (data == null) return null;
    return AppUser.fromMap(Map<String, dynamic>.from(data as Map));
  }

  static Future<void> deleteUser() async {
    final box = Hive.box(_userBox);
    await box.delete('current_user');
  }


  static Future<void> saveThemeMode(ThemeMode mode) async {
    final box = Hive.box(_settingsBox);
    await box.put('theme_mode', mode.index);
  }

  static ThemeMode getThemeMode() {
    final box = Hive.box(_settingsBox);
    final migrated = box.get('theme_migrated_v2', defaultValue: false);
    if (migrated == false) {
      box.put('theme_migrated_v2', true);
      box.delete('theme_mode');
      return ThemeMode.system;
    }
    final index = box.get('theme_mode');
    if (index == null) return ThemeMode.system;
    return ThemeMode.values[index as int];
  }

  static Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box(_settingsBox);
    await box.put(key, value);
  }

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    final box = Hive.box(_settingsBox);
    return box.get(key, defaultValue: defaultValue);
  }
}
