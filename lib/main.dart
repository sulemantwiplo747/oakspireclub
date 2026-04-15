import 'dart:async';
import 'dart:io';

import 'package:bourboneur/Core/BlogController.dart';
import 'package:bourboneur/Core/Controller.dart';
import 'package:bourboneur/Core/notification_services.dart';
import 'package:bourboneur/pages/splash.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ByteData data = await rootBundle.load('assets/certificate/cert.pem');
  SecurityContext context = SecurityContext.defaultContext;
  context.setTrustedCertificatesBytes(data.buffer.asUint8List());

  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform
  );
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await NotificationService().initInfo();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Get.put(Controller(), permanent: true);
  Get.put(BlogController(), permanent: true);
  runZonedGuarded(
    () => runApp(MyApp(analytics: FirebaseAnalytics.instance)),
    (error, stack) =>
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.analytics});

  final FirebaseAnalytics analytics;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bourboneur',
      navigatorObservers: <NavigatorObserver>[
        FirebaseAnalyticsObserver(analytics: widget.analytics),
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF000000),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(color: Color(0xFFd5bb9b)),
          headlineMedium: TextStyle(
            fontFamily: 'Arial',
            color: Color(0xFFd5bb9b),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Color(0xFFd5bb9b)),
          bodySmall: TextStyle(
            fontFamily: 'Arial',
            color: Color(0xFFd5bb9b),
            fontSize: 14,
          ),
          labelMedium: TextStyle(
            fontFamily: 'Arial',
            color: Colors.white,
            fontSize: 14,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Arial',
            fontWeight: FontWeight.bold,
            color: Color(0xFFd5bb9b),
            fontSize: 14,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF000000).withOpacity(1),
          foregroundColor: const Color(0xFF000000).withOpacity(1),
          surfaceTintColor: const Color(0xFF000000).withOpacity(1),
          iconTheme: const IconThemeData(color: Color(0xffe17f2f)),
        ),
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color(0xFF000000).withOpacity(1),
        ),
        useMaterial3: true,
      ),
      home: const SplashPage(),
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: EasyLoading.init()(context, child),
        );
      },
    );
  }
}
