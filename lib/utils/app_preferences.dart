import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _keyToken = 'token';

  static late SharedPreferences _preferences;

  // Initialize shared preferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Token getter
  static String? getToken() {
    return _preferences.getString(_keyToken);
  }

  // Token setter
  static Future<bool> setToken(String token) async {
    return await _preferences.setString(_keyToken, token);
  }

  // Clear token
  static Future<bool> clearToken() async {
    return await _preferences.remove(_keyToken);
  }
}
