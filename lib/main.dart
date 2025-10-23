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
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _initNotifications() async {
  tz.initializeTimeZones();

  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initSettings = InitializationSettings(
    android: androidInit,
    iOS: iosInit,
  );

  // Initialize with onDidReceiveNotificationResponse callback
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        final payloadData = jsonDecode(response.payload!);
        // Handle notification tap - navigate to bill details or relevant screen
        Get.toNamed(
          RouteNames.billDetailScreen,
          arguments: {'billId': payloadData['billId']},
        );
      }
    },
  );

  await Permission.notification.request();
  await Permission.scheduleExactAlarm.request();
}

// Future<void> _initNotifications() async {
//   // Initialize time zones
//   tz.initializeTimeZones();

//   // Android settings
//   const AndroidInitializationSettings androidInit =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   // iOS settings (optional)
//   const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

//   const InitializationSettings initSettings = InitializationSettings(
//     android: androidInit,
//     iOS: iosInit,
//   );

//   // Initialize plugin
//   await flutterLocalNotificationsPlugin.initialize(initSettings);

//   // Request permissions (especially for Android 13+)
//   // await flutterLocalNotificationsPlugin
//   //     .resolvePlatformSpecificImplementation<
//   //       AndroidFlutterLocalNotificationsPlugin
//   //     >()
//   //     ?.requestNotificationsPermission();
//   await Permission.notification.request();
//   await Permission.scheduleExactAlarm.request();
// }

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
