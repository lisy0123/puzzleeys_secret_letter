import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<void> save(String key, String value) async {
    final prefs = await _prefs;
    prefs.setString(key, value);
  }

  static Future<String?> get(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  static Future<void> saveInt(String key, int value) async {
    final prefs = await _prefs;
    prefs.setInt(key, value);
  }

  static Future<int> getInt(String key) async {
    final prefs = await _prefs;
    return prefs.getInt(key) ?? 0;
  }

  static Future<void> saveDouble(String key, double value) async {
    final prefs = await _prefs;
    prefs.setDouble(key, value);
  }

  static Future<double?> getDouble(String key) async {
    final prefs = await _prefs;
    return prefs.getDouble(key);
  }

  static Future<void> saveBool(String key, bool value) async {
    final prefs = await _prefs;
    prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }

  static Future<void> delete(String key) async {
    final prefs = await _prefs;
    prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await _prefs;
    prefs.clear();
  }
}
