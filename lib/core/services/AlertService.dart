import 'dart:convert';

import 'package:flutter/material.dart';

import 'notification_services.dart';

class AlertService {
  static Future<void> sendSecurityAlert({
    required String email,
    required String alertType,
    required String title,
    required String message,
  }) async {
    try {
      await _sendPushNotification(title, message, alertType);
      _logSecurityEvent(email, alertType);
    } catch (e) {
      debugPrint('Error sending security alert: $e');
    }
  }

  static Future<void> _sendPushNotification(String title, String message, String alertType) async {
    try {
      await NotificationService.showLocalNotification(
        title: title,
        body: message,
        payload: jsonEncode({
          'type': 'security_alert',
          'alert_type': alertType,
          'timestamp': DateTime.now().toString(),
        }),
      );
      debugPrint('📱 Security push notification sent: $title');
    } catch (e) {
      debugPrint('Error sending security push notification: $e');
    }
  }

  static void _logSecurityEvent(String email, String alertType) {
    debugPrint('🔐 SECURITY EVENT LOGGED');
    debugPrint('User: $email');
    debugPrint('Event: $alertType');
    debugPrint('Time: ${DateTime.now()}');
    debugPrint('------------------------');
  }

  static Future<void> sendAccountLockedAlert(String email) async {
    await sendSecurityAlert(
      email: email,
      alertType: 'account_locked',
      title: '🔒 الحساب مغلق - تنبيه أمني',
      message:
      'تم إغلاق حسابك مؤقتاً بسبب تعدد محاولات الدخول الفاشلة. سيتم فتح الحساب تلقائياً بعد 15 دقيقة.',
    );
  }

  static Future<void> sendSuspiciousActivityAlert(String email, int failedAttempts) async {
    await sendSecurityAlert(
      email: email,
      alertType: 'suspicious_activity',
      title: '⚠️ نشاط مشبوه',
      message:
      'تم رصد $failedAttempts محاولات دخول فاشلة على حسابك. إذا لم تكن أنت، يرجى تأمين حسابك فوراً.',
    );
  }

  static Future<void> sendFailedLoginAlert(String email, int attemptCount) async {
    await sendSecurityAlert(
      email: email,
      alertType: 'failed_login',
      title: '🚫 محاولة دخول فاشلة',
      message: 'تمت محاولة دخول فاشلة على حسابك. المحاولة رقم $attemptCount من 5.',
    );
  }
}
