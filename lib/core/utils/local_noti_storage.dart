import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalNotificationStorage {
  static const _storageKey = 'local_notifications';

  static Future<List<Map<String, dynamic>>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.cast<Map<String, dynamic>>();
  }

  static Future<void> addNotification(Map<String, dynamic> notification) async {
    final notifications = await getNotifications();
    notifications.insert(0, notification);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(notifications));
  }

  static Future<void> saveNotifications(List<Map<String, dynamic>> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(notifications));
  }

  static Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
