import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const String _remindersEnabledKey = 'remindersEnabled';
  static const String _storageMethodKey = 'storageMethod';

  bool _remindersEnabled = true;
  String _storageMethod = 'shared_preferences'; // Default

  bool get remindersEnabled => _remindersEnabled;
  String get storageMethod => _storageMethod;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _remindersEnabled = prefs.getBool(_remindersEnabledKey) ?? true;
    _storageMethod = prefs.getString(_storageMethodKey) ?? 'shared_preferences';
    notifyListeners();
  }

  Future<void> toggleReminders(bool enable) async {
    _remindersEnabled = enable;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_remindersEnabledKey, enable);
    notifyListeners();
  }

  Future<void> setStorageMethod(String method) async {
    _storageMethod = method;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageMethodKey, method);
    notifyListeners();
  }
}
