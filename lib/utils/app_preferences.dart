import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _keyToken = 'token';
  static const String _keyUserId = 'user_id';
  static const String _keyName = 'name';
  static const String _keyEmail = 'email';
  static const String _keyPhone = 'phone';
  static const String _keyHasNfc = 'has_nfc';
  static const String _keyHasFingerprint = 'has_fingerprint';

  static late SharedPreferences _preferences;

  // Initialize shared preferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // User data setters
  static Future<bool> setUserData({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String token,
    required bool hasNfc,
    required bool hasFingerprint,
  }) async {
    await _preferences.setString(_keyUserId, id);
    await _preferences.setString(_keyName, name);
    await _preferences.setString(_keyEmail, email);
    await _preferences.setString(_keyPhone, phone);
    await _preferences.setString(_keyToken, token);
    await _preferences.setBool(_keyHasNfc, hasNfc);
    await _preferences.setBool(_keyHasFingerprint, hasFingerprint);
    return true;
  }

  // Individual getters
  static String? getUserId() => _preferences.getString(_keyUserId);
  static String? getName() => _preferences.getString(_keyName);
  static String? getEmail() => _preferences.getString(_keyEmail);
  static String? getPhone() => _preferences.getString(_keyPhone);
  static String? getToken() => _preferences.getString(_keyToken);
  static bool? getHasNfc() => _preferences.getBool(_keyHasNfc);
  static bool? getHasFingerprint() => _preferences.getBool(_keyHasFingerprint);

  // Clear all user data
  static Future<bool> clearUserData() async {
    await _preferences.remove(_keyUserId);
    await _preferences.remove(_keyName);
    await _preferences.remove(_keyEmail);
    await _preferences.remove(_keyPhone);
    await _preferences.remove(_keyToken);
    await _preferences.remove(_keyHasNfc);
    await _preferences.remove(_keyHasFingerprint);
    return true;
  }
}
