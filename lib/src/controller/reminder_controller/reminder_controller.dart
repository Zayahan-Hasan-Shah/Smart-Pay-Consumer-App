import 'dart:convert';

import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/service/storage_service/storage_services.dart';
// import 'package:consumer_app/src/service/reminder_service/reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:consumer_app/main.dart';

class ReminderController extends GetxController {
  static final Map<String, ReminderController> _reminderControllers = {};
  // final ReminderService _reminderService = ReminderService();

  final String billId;
  final String billName;

  ReminderController({required this.billId, required this.billName});

  var isReminderOn = false.obs;
  var reminderDate = Rxn<DateTime>();

  static ReminderController? getByBillId(String billId) {
    return _reminderControllers[billId];
  }

  static List<ReminderController> get allControllers =>
      _reminderControllers.values.toList();

  static void registerController(String billId, ReminderController controller) {
    _reminderControllers[billId] = controller;
  }

  @override
  void onClose() {
    _reminderControllers.removeWhere((key, value) => value == this);
    super.onClose();
  }

  ///  Main toggle logic
  Future<void> toggleReminder(
    BuildContext context,
    bool value,
    DateTime billDueDate,
  ) async {
    DateTime now = DateTime.now();

    if (value) {
      if (billDueDate.isBefore(now)) {
        Get.snackbar(
          "Invalid Action",
          "This bill's due date has already passed.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.danger,
          colorText: AppColors.white,
        );
        isReminderOn.value = false;
        return;
      }

      //  Ask user to enable exact alarms (Android 12+)
      if (!await _ensureExactAlarmPermission()) {
        isReminderOn.value = false;
        return;
      }

      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: billDueDate,
        helpText: "Select reminder date (before due date)",
      );

      if (selectedDate != null && selectedDate.isBefore(billDueDate)) {
        reminderDate.value = selectedDate;
        isReminderOn.value = true;

        await _scheduleNotification(selectedDate, billDueDate);

        Get.snackbar(
          "Reminder Set",
          "Reminder scheduled for ${DateFormat('dd MMM, yyyy').format(selectedDate)}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
        );
      } else {
        isReminderOn.value = false;
      }
    } else {
      reminderDate.value = null;
      isReminderOn.value = false;

      //  Cancel scheduled notification
      await flutterLocalNotificationsPlugin.cancel(billId.hashCode);

      Get.snackbar(
        "Reminder Cleared",
        "You’ve turned off the reminder",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  ///  Schedule the notification (safe & cross-platform)
  Future<void> _scheduleNotification(
    DateTime startDate,
    DateTime dueDate,
  ) async {
    final StorageServices _storage = StorageServices();
    final deviceId = await _storage.read('device_id');

    if (deviceId == null) {
      Get.snackbar(
        "Error",
        "Device ID not found. Please login again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final random = Random();
    final now = DateTime.now();
    final start = startDate.isBefore(now) ? now : startDate;

    // Cancel any old notifications for this bill
    await flutterLocalNotificationsPlugin.cancel(billId.hashCode);

    int notificationId = billId.hashCode;
    DateTime current = DateTime(start.year, start.month, start.day);

    while (!current.isAfter(dueDate)) {
      // Schedule 2–3 random times in the day
      int randomCount = 2 + random.nextInt(2); // 2 or 3 times/day
      for (int i = 0; i < randomCount; i++) {
        // Generate random time between 9 AM and 9 PM
        final hour = 9 + random.nextInt(12);
        final minute = random.nextInt(60);

        final scheduledDate = tz.TZDateTime(
          tz.local,
          current.year,
          current.month,
          current.day,
          hour,
          minute,
        );

        if (scheduledDate.isAfter(now)) {
          await flutterLocalNotificationsPlugin.zonedSchedule(
            notificationId + i,
            'Bill Payment Reminder',
            'Your $billName payment of is due on ${DateFormat('MMM dd').format(dueDate)}',
            scheduledDate,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'bill_reminder_channel',
                'Bill Reminders',
                channelDescription: 'Notifications for bill payment reminders',
                importance: Importance.high,
                priority: Priority.high,
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents
                .time, // Changed from uiLocalNotificationDateInterpretation
            payload: jsonEncode({'billId': billId, 'deviceId': deviceId}),
          );
        }
      }
      current = current.add(const Duration(days: 1));
    }

    Get.snackbar(
      "Reminder Set",
      "You'll receive reminders until ${DateFormat('dd MMM, yyyy').format(dueDate)}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
    );
  }
  // Future<void> _scheduleNotification(
  //   DateTime startDate,
  //   DateTime dueDate,
  // ) async {
  //   final StorageServices _storage = StorageServices();
  //   final deviceId = await _storage.read('device_id');

  //   if (deviceId == null) {
  //     Get.snackbar(
  //       "Error",
  //       "Please login again.",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //     return;
  //   }

  //   final random = Random();
  //   final now = DateTime.now();
  //   final start = startDate.isBefore(now) ? now : startDate;

  //   // Cancel any old notifications for this bill
  //   await flutterLocalNotificationsPlugin.cancel(billId.hashCode);

  //   int notificationId = billId.hashCode;
  //   DateTime current = DateTime(start.year, start.month, start.day);

  //   while (!current.isAfter(dueDate)) {
  //     // Schedule 2–3 random times in the day
  //     int randomCount = 2 + random.nextInt(2); // 2 or 3 times/day
  //     for (int i = 0; i < randomCount; i++) {
  //       // Generate a random time between 9 AM and 9 PM
  //       int randomHour = 9 + random.nextInt(12);
  //       int randomMinute = random.nextInt(60);

  //       final randomDateTime = DateTime(
  //         current.year,
  //         current.month,
  //         current.day,
  //         randomHour,
  //         randomMinute,
  //       );

  //       // Skip times already in the past
  //       if (randomDateTime.isBefore(now)) continue;

  //       final tzDate = tz.TZDateTime.from(randomDateTime, tz.local);

  //       await flutterLocalNotificationsPlugin.zonedSchedule(
  //         notificationId++,
  //         'Bill Reminder',
  //         'Your bill "$billName" is due on ${DateFormat('dd MMM').format(dueDate)}',
  //         tzDate,
  //         const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             'reminder_channel',
  //             'Bill Reminders',
  //             channelDescription: 'Reminders for upcoming bills',
  //             importance: Importance.high,
  //             priority: Priority.high,
  //           ),
  //           iOS: DarwinNotificationDetails(),
  //         ),
  //         matchDateTimeComponents: DateTimeComponents.dateAndTime,
  //         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //       );
  //     }

  //     // Move to next day
  //     current = current.add(const Duration(days: 1));
  //   }

  //   Get.snackbar(
  //     "Random Reminders Set",
  //     "You'll receive random reminders until ${DateFormat('dd MMM, yyyy').format(dueDate)}",
  //     snackPosition: SnackPosition.BOTTOM,
  //     backgroundColor: AppColors.success,
  //     colorText: AppColors.white,
  //   );
  // }

  ///  Checks & helps user enable Exact Alarm permission (Android 12+)
  Future<bool> _ensureExactAlarmPermission() async {
    if (GetPlatform.isIOS) return true; // iOS doesn't need this

    final status = await Permission.scheduleExactAlarm.status;

    if (status.isGranted) return true;

    Get.snackbar(
      "Permission Required",
      "Please enable 'Alarms & reminders' for this app in Settings.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );

    await openAppSettings();
    return false;
  }
}
