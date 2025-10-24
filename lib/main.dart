import 'dart:convert';

import 'package:consumer_app/src/core/constants/app_theme.dart';
import 'package:consumer_app/src/routes/app_routes.dart';
import 'package:consumer_app/src/routes/route_names.dart';
import 'package:consumer_app/src/view/screens/on_boarding/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'src/controller/theme_controller/theme_controller.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _initNotifications() async {
  // Initialize timezone data
  tz.initializeTimeZones();

  try {
    // Dynamically detect timezone offset and correct Etc/GMT logic
    final now = DateTime.now();
    final offset = now.timeZoneOffset;

    // Note: Etc/GMT sign is reversed by convention!
    final offsetHours = offset.inHours;
    final gmtOffset = offsetHours == 0
        ? 'Etc/GMT'
        : 'Etc/GMT${offsetHours > 0 ? '-' : '+'}${offsetHours.abs()}';

    // Set local timezone
    tz.setLocalLocation(tz.getLocation(gmtOffset));
    debugPrint('🕓 Timezone successfully set to: ${tz.local.name}');
  } catch (e) {
    debugPrint('⚠️ Failed to detect local timezone, defaulting to UTC: $e');
    tz.setLocalLocation(tz.getLocation('UTC'));
  }

  // Android initialization
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS initialization
  const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  // Combine initialization settings
  const InitializationSettings initSettings = InitializationSettings(
    android: androidInit,
    iOS: iosInit,
  );

  // Initialize plugin with callback
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        final payloadData = jsonDecode(response.payload!);
        Get.toNamed(
          RouteNames.billDetailScreen,
          arguments: {'billId': payloadData['billId']},
        );
      }
    },
  );

  // Request permissions (Android 13+ & iOS)
  await Permission.notification.request();
  await Permission.scheduleExactAlarm.request();

  // Create notification channel for Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'bill_reminder_channel',
    'Bill Reminders',
    description: 'Bill due date reminders',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  debugPrint('✅ Notifications initialized in timezone: ${tz.local.name}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return Sizer(
      builder: (context, orientation, deviceType) {
        return Obx(() {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            getPages: AppRoutes.routes,
            initialRoute: RouteNames.splashScreen,
            title: 'Consumer App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeController.theme,
            home: SplashScreen(),
          );
        });
      },
    );
  }
}
