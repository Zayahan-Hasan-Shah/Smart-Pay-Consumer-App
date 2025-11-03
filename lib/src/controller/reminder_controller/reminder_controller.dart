import 'dart:convert';
import 'dart:developer';
import 'package:consumer_app/main.dart';
import 'package:consumer_app/src/service/reminder_service/reminder_service.dart';
import 'package:consumer_app/src/service/storage_service/storage_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class ReminderController extends GetxController {
  static final List<ReminderController> allControllers = [];

  final int billId;
  final int consumerNumberId;

  // Whether reminder is currently enabled
  var isReminderEnabled = false.obs;

  final ReminderService _service = ReminderService();

  ReminderController({
    required this.billId,
    required this.consumerNumberId,
    bool initialStatus = false,
  }) {
    isReminderEnabled.value = initialStatus;
    allControllers.add(this);
  }

  /// Toggle reminder on/off — directly hits API without asking user for date
  Future<void> toggleReminder() async {
    try {
      final newStatus = !isReminderEnabled.value;

      final response = await _service.setReminder(
        consumerNumberId: consumerNumberId,
        billId: billId,
        isEnabled: newStatus,
      );

      if (response != null) {
        isReminderEnabled.value = newStatus;
        _sendImmediateTestNotification();
        log(
          "Reminder ${newStatus ? 'enabled' : 'disabled'} for billId=$billId",
        );
      } else {
        log("Failed to update reminder for billId=$billId");
      }
    } catch (e) {
      log("Error toggling reminder for billId=$billId: $e");
    }
  }

  Future<void> _sendImmediateTestNotification() async {
    final StorageServices _storage = StorageServices();
    final deviceId = await _storage.read('device_id');

    if (deviceId == null) {
      log("Device ID not found for immediate notification");
      return;
    }

    try {
      await flutterLocalNotificationsPlugin.show(
        billId.hashCode + 3000, // Use a different ID for immediate test
        '✅ Reminder Set Successfully!',
        'Your reminder is now active. You will be notified on the scheduled date.',
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
              'Your reminder is now active.',
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

      log('IMMEDIATE notification sent! Check your notification panel!');
    } catch (e) {
      log('Error sending immediate notification: $e');
    }
  }

  @override
  void onClose() {
    allControllers.remove(this);
    super.onClose();
  }
}
