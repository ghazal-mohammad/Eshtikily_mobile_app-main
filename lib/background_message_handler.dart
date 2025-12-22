import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'core/services/notification_services.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
  debugPrint('Background message data: ${message.data}');
  debugPrint('Background message notification: ${message.notification?.title}');

  await NotificationService.handleBackgroundMessage(message);
}

