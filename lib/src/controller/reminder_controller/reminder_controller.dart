import 'dart:convert';

import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/service/storage_service/storage_services.dart';
// import 'package:consumer_app/src/service/reminder_service/reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' hide log;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:consumer_app/main.dart';
import 'package:timezone/data/latest_all.dart' as tz;

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
        // If user selects today's date, set it to current time + 1 minute to avoid "past time" issue
        DateTime reminderDateTime = selectedDate;
        if (selectedDate.day == now.day &&
            selectedDate.month == now.month &&
            selectedDate.year == now.year) {
          // User selected today, set to current time + 1 minute
          reminderDateTime = DateTime.now().add(const Duration(minutes: 1));
        } else {
          // User selected future date, set to 9 AM of that day
          reminderDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            9,
            0,
          );
        }

        reminderDate.value = reminderDateTime;
        isReminderOn.value = true;

        await _scheduleNotification(reminderDateTime, billDueDate);

        // Send immediate notification for testing
        await _sendImmediateTestNotification();

        Get.snackbar(
          "Reminder Set",
          "Reminder scheduled for ${DateFormat('dd MMM, yyyy hh:mm a').format(reminderDateTime)}. You'll get 5 daily reminders until then!",
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
    DateTime reminderDateTime,
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

    // ✅ Initialize the tz database (must call once)
    tz.initializeTimeZones();

    // Use the local timezone that was set in main.dart
    final now = tz.TZDateTime.now(tz.local);
    debugPrint("🕓 Current local time: $now");

    // Convert the reminder DateTime to TZDateTime using local timezone
    final reminderTime = tz.TZDateTime.from(reminderDateTime, tz.local);
    debugPrint("📅 Reminder time: $reminderTime");

    if (reminderTime.isBefore(now)) {
      Get.snackbar(
        "Invalid Time",
        "Selected reminder time is in the past.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    await flutterLocalNotificationsPlugin.cancel(billId.hashCode);

    int baseId = billId.hashCode;

    // ✅ Main reminder
    await flutterLocalNotificationsPlugin.zonedSchedule(
      baseId,
      'Bill Payment Reminder',
      'Your $billName is due on ${DateFormat('MMM dd, yyyy hh:mm a').format(dueDate)}',
      reminderTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'bill_reminder_channel',
          'Bill Reminders',
          channelDescription: 'Bill due date reminders',
          importance: Importance.max,
          priority: Priority.max,
          icon: 'app_logo',
          showWhen: true,
          enableVibration: true,
          playSound: true,
          largeIcon: DrawableResourceAndroidBitmap('app_logo'),
          styleInformation: BigTextStyleInformation(
            'Your $billName is due on ${DateFormat('MMM dd, yyyy hh:mm a').format(dueDate)}. Don\'t forget to pay!',
            htmlFormatBigText: true,
            contentTitle: 'Bill Payment Reminder',
            htmlFormatContentTitle: true,
          ),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
      payload: jsonEncode({'billId': billId, 'deviceId': deviceId}),
    );

    debugPrint(
      '✅ Main notification scheduled at: ${DateFormat('yyyy-MM-dd hh:mm:ss a').format(reminderTime)}',
    );

    // ✅ Two extra random ones (30–180 min before)
    const minBefore = 30;
    const maxBefore = 180;
    int extraId = 1;

    for (int i = 0; i < 2; i++) {
      final minutesBefore = minBefore + random.nextInt(maxBefore - minBefore);
      final extraTime = reminderTime.subtract(Duration(minutes: minutesBefore));

      if (extraTime.isAfter(now)) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          baseId + extraId,
          'Upcoming Bill Reminder',
          'Heads up — your $billName is due on ${DateFormat('MMM dd').format(dueDate)}',
          extraTime,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'bill_reminder_channel',
              'Bill Reminders',
              channelDescription: 'Upcoming bill payment reminders',
              importance: Importance.high,
              priority: Priority.high,
              icon: 'app_logo',
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: null,
          payload: jsonEncode({'billId': billId, 'deviceId': deviceId}),
        );

        debugPrint(
          '🕐 Extra reminder scheduled at: ${DateFormat('yyyy-MM-dd hh:mm:ss a').format(extraTime)}',
        );
        extraId++;
      }
    }

    // ✅ Schedule 5 notifications per day from now until reminder date
    await _scheduleDailyNotifications(reminderDateTime);

    debugPrint('✅ All reminders scheduled successfully');
  }

  /// Schedule 5 notifications per day from now until reminder date
  Future<void> _scheduleDailyNotifications(DateTime reminderDate) async {
    final StorageServices _storage = StorageServices();
    final deviceId = await _storage.read('device_id');

    if (deviceId == null) {
      debugPrint("❌ Device ID not found for daily notifications");
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final reminderDay = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
    );

    // Schedule notifications for each day from today until reminder date
    DateTime currentDay = today;
    int notificationId =
        billId.hashCode + 10000; // Start from a high number to avoid conflicts

    while (!currentDay.isAfter(reminderDay)) {
      // Skip if it's the same day as the main reminder (we already have that scheduled)
      if (currentDay.isAtSameMomentAs(reminderDay)) {
        currentDay = currentDay.add(const Duration(days: 1));
        continue;
      }

      // 5 notification times per day: 9 AM, 12 PM, 3 PM, 6 PM, 9 PM
      final List<int> hours = [9, 12, 15, 18, 21];

      for (int hour in hours) {
        final notificationTime = DateTime(
          currentDay.year,
          currentDay.month,
          currentDay.day,
          hour,
          0,
        );

        // Only schedule if the time is in the future
        if (notificationTime.isAfter(now)) {
          final tzNotificationTime = tz.TZDateTime.from(
            notificationTime,
            tz.local,
          );

          await flutterLocalNotificationsPlugin.zonedSchedule(
            notificationId++,
            'Daily Bill Reminder',
            'Don\'t forget about your $billName payment!',
            tzNotificationTime,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'bill_reminder_channel',
                'Bill Reminders',
                channelDescription: 'Daily bill payment reminders',
                importance: Importance.high,
                priority: Priority.high,
                icon: 'app_logo',
                showWhen: true,
                enableVibration: true,
                playSound: true,
                largeIcon: DrawableResourceAndroidBitmap('app_logo'),
                styleInformation: BigTextStyleInformation(
                  'Don\'t forget about your $billName payment! Stay on top of your bills.',
                  htmlFormatBigText: true,
                  contentTitle: 'Daily Bill Reminder',
                  htmlFormatContentTitle: true,
                ),
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: null,
            payload: jsonEncode({
              'billId': billId,
              'deviceId': deviceId,
              'isDailyReminder': true,
              'day': currentDay.toIso8601String(),
            }),
          );

          debugPrint(
            '📅 Daily notification scheduled for: ${DateFormat('yyyy-MM-dd hh:mm a').format(tzNotificationTime)}',
          );
        }
      }

      currentDay = currentDay.add(const Duration(days: 1));
    }

    debugPrint(
      '✅ Daily notifications scheduled from today until ${DateFormat('yyyy-MM-dd').format(reminderDay)}',
    );
  }

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

  /// Test method to schedule immediate notification for debugging
  Future<void> testImmediateNotification() async {
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

    // Schedule notification for 5 seconds from now
    final now = DateTime.now().add(const Duration(seconds: 5));
    final reminderTime = tz.TZDateTime.from(now, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      billId.hashCode + 999, // Use a different ID for test
      'Test Bill Payment Reminder',
      'Test notification for $billName - This is a test!',
      reminderTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'bill_reminder_channel',
          'Bill Reminders',
          channelDescription: 'Bill due date reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: 'app_logo',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
      payload: jsonEncode({'billId': billId, 'deviceId': deviceId}),
    );

    debugPrint(
      '🧪 Test notification scheduled for: ${DateFormat('yyyy-MM-dd hh:mm:ss a').format(reminderTime)}',
    );

    Get.snackbar(
      "Test Notification",
      "Test notification scheduled for 5 seconds from now",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  /// Public method to test notifications - call this from your UI
  static Future<void> testNotificationForBill(
    String billId,
    String billName,
  ) async {
    final controller = ReminderController(billId: billId, billName: billName);
    await controller.testImmediateNotification();
  }

  /// Test immediate system notification (appears right now)
  Future<void> testImmediateSystemNotification() async {
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

    try {
      await flutterLocalNotificationsPlugin.show(
        billId.hashCode + 2000, // Use a different ID for immediate test
        'IMMEDIATE TEST: Bill Reminder',
        'This is a system notification! If you see this, notifications are working!',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'bill_reminder_channel',
            'Bill Reminders',
            channelDescription: 'Bill due date reminders',
            importance: Importance.max,
            priority: Priority.max,
            icon: 'app_logo',
            showWhen: true,
            enableVibration: true,
            playSound: true,
            largeIcon: DrawableResourceAndroidBitmap('app_logo'),
            styleInformation: BigTextStyleInformation(
              'This is a system notification! If you see this, notifications are working! Your $billName reminder system is functional.',
              htmlFormatBigText: true,
              contentTitle: 'IMMEDIATE TEST: Bill Reminder',
              htmlFormatContentTitle: true,
            ),
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode({
          'billId': billId,
          'deviceId': deviceId,
          'isImmediateTest': true,
        }),
      );

      debugPrint(
        '🚀 IMMEDIATE notification sent! Check your notification panel!',
      );

      Get.snackbar(
        "Test Sent",
        "Check your notification panel - you should see a system notification!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error sending immediate notification: $e');
      Get.snackbar(
        "Error",
        "Failed to send notification: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Send immediate notification when reminder is set (for testing)
  Future<void> _sendImmediateTestNotification() async {
    final StorageServices _storage = StorageServices();
    final deviceId = await _storage.read('device_id');

    if (deviceId == null) {
      debugPrint("Device ID not found for immediate notification");
      return;
    }

    try {
      await flutterLocalNotificationsPlugin.show(
        billId.hashCode + 3000, // Use a different ID for immediate test
        '✅ Reminder Set Successfully!',
        'Your $billName reminder is now active. You will be notified on the scheduled date.',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'bill_reminder_channel',
            'Bill Reminders',
            channelDescription: 'Bill due date reminders',
            importance: Importance.max,
            priority: Priority.max,
            icon: 'app_logo',
            showWhen: true,
            enableVibration: true,
            playSound: true,
            largeIcon: DrawableResourceAndroidBitmap('app_logo'),
            styleInformation: BigTextStyleInformation(
              'Your $billName reminder is now active.',
              htmlFormatBigText: true,
              contentTitle: 'Reminder Set Successfully!',
              htmlFormatContentTitle: true,
            ),
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode({
          'billId': billId,
          'deviceId': deviceId,
          'isImmediateConfirmation': true,
        }),
      );

      debugPrint(
        '🚀 IMMEDIATE notification sent! Check your notification panel!',
      );
    } catch (e) {
      debugPrint('❌ Error sending immediate notification: $e');
    }
  }
}
