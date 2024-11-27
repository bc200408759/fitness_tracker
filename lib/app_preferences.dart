import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static final AppPreferences _instance = AppPreferences._internal();

  factory AppPreferences() => _instance;

  SharedPreferences? _prefs;

  AppPreferences._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    print('SharedPreferences initialized.');
  }

  Future<void> saveData(String key, dynamic value) async {
    if (_prefs == null) return;
    if (value is String) {
      await _prefs!.setString(key, value);
    } else if (value is int) {
      await _prefs!.setInt(key, value);
    } else if (value is bool) {
      await _prefs!.setBool(key, value);
    } else if (value is double) {
      await _prefs!.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs!.setStringList(key, value);
    } else if (value is Map) {
      // Encode Map as JSON
      await _prefs!.setString(key, jsonEncode(value));
    }
    print('Data saved: $key = $value');
  }

  dynamic getData(String key) {
    final data = _prefs?.get(key);
    if (data is String) {
      try {
        // Try decoding JSON for Maps
        final decoded = jsonDecode(data);
        if (decoded is Map) {
          print('Data retrieved as Map: $key = $decoded');
          return decoded;
        }
      } catch (e) {
        // Not JSON
      }
    }
    print('Data retrieved: $key = $data');
    return data;
  }

  Future<void> removeData(String key) async {
    if (_prefs != null) {
      await _prefs!.remove(key);
      print('Data removed: $key');
    }
  }

  Future<void> clearAll() async {
    if (_prefs != null) {
      await _prefs!.clear();
      print('All data cleared.');
    }
  }
}
