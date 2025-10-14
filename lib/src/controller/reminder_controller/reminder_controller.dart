import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

// class ReminderController extends GetxController {
//   var isReminderOn = false.obs;
//   var reminderDate = Rxn<DateTime>();

//   Future<void> toggleReminder(
//     BuildContext context,
//     bool value,
//     DateTime billDueDate,
//   ) async {
//     if (value) {
//       DateTime now = DateTime.now();

//       //  If due date already passed
//       if (billDueDate.isBefore(now)) {
//         Get.snackbar(
//           "Invalid Action",
//           "This bill's due date has already passed.",
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         isReminderOn.value = false;
//         return;
//       }

//       //  Safe range: today → due date
//       DateTime? selectedDate = await showDatePicker(
//         context: context,
//         initialDate: now.isBefore(billDueDate) ? now : billDueDate,
//         firstDate: now,
//         lastDate: billDueDate,
//         helpText: "Select reminder date (before due date)",
//       );

//       if (selectedDate != null) {
//         if (selectedDate.isAfter(billDueDate)) {
//           Get.snackbar(
//             "Invalid Date",
//             "Reminder cannot be after the due date (${DateFormat('dd MMM, yyyy').format(billDueDate)})",
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: AppColors.danger,
//             colorText: AppColors.white,
//           );
//           isReminderOn.value = false;
//           return;
//         }

//         reminderDate.value = selectedDate;
//         isReminderOn.value = true;

//         Get.snackbar(
//           "Reminder Set",
//           "Reminder scheduled for ${DateFormat('dd MMM, yyyy').format(selectedDate)}",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.success,
//           colorText: AppColors.white,
//         );
//       } else {
//         isReminderOn.value = false;
//       }
//     } else {
//       reminderDate.value = null;
//       isReminderOn.value = false;
//       Get.snackbar(
//         "Reminder Cleared",
//         "You’ve turned off the reminder",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
// }

// class ReminderController extends GetxController {
//   static final Map<String, ReminderController> _reminderControllers = {};

//   final String billId; // ✅ add this field
//   final String billName;

//   ReminderController({
//     required this.billId,
//     required this.billName,
//   }); // ✅ constructor

//   var isReminderOn = false.obs;
//   var reminderDate = Rxn<DateTime>();

//   static ReminderController? getByBillId(String billId) {
//     return _reminderControllers[billId];
//   }

//   static List<ReminderController> get allControllers =>
//       _reminderControllers.values.toList();

//   static void registerController(String billId, ReminderController controller) {
//     _reminderControllers[billId] = controller;
//   }

//   @override
//   void onClose() {
//     _reminderControllers.removeWhere((key, value) => value == this);
//     super.onClose();
//   }

//   Future<void> toggleReminder(
//     BuildContext context,
//     bool value,
//     DateTime billDueDate,
//   ) async {
//     DateTime now = DateTime.now();

//     if (value) {
//       if (billDueDate.isBefore(now)) {
//         Get.snackbar(
//           "Invalid Action",
//           "This bill's due date has already passed.",
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         isReminderOn.value = false;
//         return;
//       }

//       DateTime? selectedDate = await showDatePicker(
//         context: context,
//         initialDate: now,
//         firstDate: now,
//         lastDate: billDueDate,
//         helpText: "Select reminder date (before due date)",
//       );

//       if (selectedDate != null && selectedDate.isBefore(billDueDate)) {
//         reminderDate.value = selectedDate;
//         isReminderOn.value = true;
//         Get.snackbar(
//           "Reminder Set",
//           "Reminder scheduled for ${DateFormat('dd MMM, yyyy').format(selectedDate)}",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: AppColors.success,
//           colorText: AppColors.white,
//         );
//       } else {
//         isReminderOn.value = false;
//       }
//     } else {
//       reminderDate.value = null;
//       isReminderOn.value = false;
//       Get.snackbar(
//         "Reminder Cleared",
//         "You’ve turned off the reminder",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
// }

import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:consumer_app/main.dart'; // ✅ Make sure this imports your global plugin instance

class ReminderController extends GetxController {
  static final Map<String, ReminderController> _reminderControllers = {};

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

  /// 🧩 Main toggle logic
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

      // 🔐 Ask user to enable exact alarms (Android 12+)
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

        await _scheduleNotification(selectedDate);

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

      // ❌ Cancel scheduled notification
      await flutterLocalNotificationsPlugin.cancel(billId.hashCode);

      Get.snackbar(
        "Reminder Cleared",
        "You’ve turned off the reminder",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// 🕒 Schedule the notification (safe & cross-platform)
  Future<void> _scheduleNotification(DateTime date) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(date, tz.local);

    // Check if user granted exact alarm permission
    final bool hasExactAlarmPermission =
        await Permission.scheduleExactAlarm.status.isGranted;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      billId.hashCode,
      'Bill Reminder',
      'Your bill "$billName" is due soon!',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Bill Reminders',
          channelDescription: 'Reminders for upcoming bills',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      // 👇 Automatically fallback to inexact alarms if not granted
      androidScheduleMode: hasExactAlarmPermission
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// 🔐 Checks & helps user enable Exact Alarm permission (Android 12+)
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