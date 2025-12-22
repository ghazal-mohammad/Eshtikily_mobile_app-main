
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthStorage {
static const String _authTokenKey = 'auth_token';
static const String _userDataKey = 'user_data';
static const String _isLoggedInKey = 'is_logged_in';

// Caching للمحسنات الأداء
static String? _cachedToken;
static Map<String, dynamic>? _cachedUserData;
static bool? _cachedIsLoggedIn;
static SharedPreferences? _prefsInstance;

static Future<SharedPreferences> get _prefs async {
_prefsInstance ??= await SharedPreferences.getInstance();
return _prefsInstance!;
}

static Future<void> saveAuthToken(String token) async {
_cachedToken = token;
_cachedIsLoggedIn = true;
final prefs = await _prefs;
await prefs.setString(_authTokenKey, token);
await prefs.setBool(_isLoggedInKey, true);
}

static Future<String?> getAuthToken() async {
if (_cachedToken != null) return _cachedToken;

final prefs = await _prefs;
_cachedToken = prefs.getString(_authTokenKey);
return _cachedToken;
}

static Future<void> saveUserData(Map<String, dynamic> userData) async {
_cachedUserData = userData;
final prefs = await _prefs;
await prefs.setString(_userDataKey, jsonEncode(userData));
}

static Future<Map<String, dynamic>?> getUserData() async {
if (_cachedUserData != null) return _cachedUserData;

final prefs = await _prefs;
final data = prefs.getString(_userDataKey);
if (data != null) {
try {
_cachedUserData = jsonDecode(data);
} catch (e) {
_cachedUserData = null;
}
}
return _cachedUserData;
}

static Future<bool> isLoggedIn() async {
if (_cachedIsLoggedIn != null) return _cachedIsLoggedIn!;

final prefs = await _prefs;
_cachedIsLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
return _cachedIsLoggedIn!;
}

static Future<void> clearAllData() async {
_cachedToken = null;
_cachedUserData = null;
_cachedIsLoggedIn = false;

final prefs = await _prefs;
await prefs.remove(_authTokenKey);
await prefs.remove(_userDataKey);
await prefs.remove(_isLoggedInKey);
}
}
