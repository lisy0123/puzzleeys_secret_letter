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

  static Future<void> delete(String key) async {
    final prefs = await _prefs;
    prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await _prefs;
    prefs.clear();
  }
}
