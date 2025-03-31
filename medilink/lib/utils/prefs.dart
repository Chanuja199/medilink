import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Clear all data in SharedPreferences
  static Future<bool> clear() async {
    await init();
    return await _prefs!.clear();
  }

  // Save string value
  static Future<bool> setString(String key, String value) async {
    await init();
    return await _prefs!.setString(key, value);
  }

  // Get string value
  static String? getString(String key, {String defaultValue = ''}) {
    init();
    return _prefs?.getString(key) ?? defaultValue;
  }

  // Save int value
  static Future<bool> setInt(String key, int value) async {
    await init();
    return await _prefs!.setInt(key, value);
  }

  // Get int value
  static int? getInt(String key, {int defaultValue = 0}) {
    init();
    return _prefs?.getInt(key) ?? defaultValue;
  }

  // Save double value
  static Future<bool> setDouble(String key, double value) async {
    await init();
    return await _prefs!.setDouble(key, value);
  }

  // Get double value
  static double getDouble(String key, {double defaultValue = 0.0}) {
    init();
    return _prefs?.getDouble(key) ?? defaultValue;
  }

  // Save bool value
  static Future<bool> setBool(String key, bool value) async {
    await init();
    return await _prefs!.setBool(key, value);
  }

  // Get bool value
  static bool getBool(String key, {bool defaultValue = false}) {
    init();
    return _prefs?.getBool(key) ?? defaultValue;
  }

  // Save object value (converts to JSON string)
  static Future<bool> setObject(String key, Object value) async {
    await init();
    String jsonString = jsonEncode(value);
    return await _prefs!.setString(key, jsonString);
  }

  // Get object value (converts from JSON string)
  static T? getObject<T>(
      String key, T Function(Map<String, dynamic>) fromJson) {
    init();
    String? jsonString = _prefs?.getString(key);
    if (jsonString == null) return null;

    try {
      Map<String, dynamic> json = jsonDecode(jsonString);
      return fromJson(json);
    } catch (e) {
      print('Error parsing JSON: $e');
      return null;
    }
  }

  // Check if key exists
  static bool containsKey(String key) {
    init();
    return _prefs?.containsKey(key) ?? false;
  }

  // Remove a specific key
  static Future<bool> remove(String key) async {
    await init();
    return await _prefs!.remove(key);
  }
}
