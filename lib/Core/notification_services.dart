import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> firebaseMessageBackgroundHandle(RemoteMessage message) async {
  log("Background Message: ${message.messageId}");
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize Notification Service
  Future<void> initInfo() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(
      initializationSettings,
      // 👇 FIXED: handle navigation here when user taps notification
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log("Notification clicked with payload: ${response.payload}");
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
        }
      },
    );

    setupInteractedMessage();
  }

  /// Handle Firebase Messaging Setup
  Future<void> setupInteractedMessage() async {
    // Handle when app opened from terminated state
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {}

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Message received in foreground: ${message.notification?.title}");
      if (message.notification != null) {
        display(message);
      }
    });

    // When app is in background and user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Message clicked: ${message.notification?.title}");
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessageBackgroundHandle);
  }

  /// Show notification
  void display(RemoteMessage message) async {
    try {
      AndroidNotificationDetails androidNotificationDetails =
          const AndroidNotificationDetails(
            '0',
            'Default Channel',
            channelDescription: 'Default channel description',
            importance: Importance.max,
            priority: Priority.high,
          );

      const DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      await _notificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: jsonEncode(message.data),
      );

      // ❌ Removed handleNavigation(message) here — now navigation only happens on tap
    } catch (e) {
      log("Error displaying notification: $e");
    }
  }
}
