import 'dart:developer';

import 'package:consumer_app/src/core/constants/api_url.dart';
import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/model/bill_model/bill_model.dart';
import 'package:consumer_app/src/service/common_service/api_service.dart';
import 'package:consumer_app/src/service/storage_service/storage_services.dart';
import 'package:get/get.dart';

class ReminderService extends GetxController {
  Future<String?> setReminder({
    required int consumerNumberId,
    required int billId,
    required bool isEnabled,
  }) async {
    try {
      final StorageServices _storage = StorageServices();
      final String? userIdStr = await _storage.read("user_id");
      final String? deviceId = await _storage.read("device_id");

      final int userId = int.parse(userIdStr!);
      var bodySent = {
        "userId": userId,
        "consumerNumberId": consumerNumberId,
        "billId": billId,
        "deviceId": deviceId,
        "remindDaysBefore": 2,
        "isEnabled": isEnabled,
      };

      var response = await APIService.post(
        api: ApiUrl.setReminderUrl,
        body: bodySent,
      );
      if (response != null) {
        Get.snackbar(
          "Successfull",
          "Reminder Set Successfully",
          colorText: AppColors.white,
          backgroundColor: AppColors.primaryColor,
          snackPosition: SnackPosition.BOTTOM,
        );
        return response;
      }
      Get.snackbar(
        "Failed",
        "Failed to Set Reminder",
        colorText: AppColors.white,
        backgroundColor: AppColors.danger,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } catch (e) {
      log("Failed to set Reminder : $e");
      return null;
    }
  }

  // Mock in-memory data list
  final List<BillModel> _mockReminders = [
    BillModel(
      billId: 'BILL001',
      billName: 'Electricity Bill',
      amount: 125.75,
      // issueDate: DateTime(2025, 10, 1),
      dueDate: DateTime(2025, 10, 25),
      expiryDate: DateTime(2025, 10, 30),
      isPaid: false,
    ),
    BillModel(
      billId: 'BILL002',
      billName: 'Water Bill',
      amount: 45.50,
      // issueDate: DateTime(2025, 9, 28),
      dueDate: DateTime(2025, 10, 20),
      expiryDate: DateTime(2025, 10, 25),
      isPaid: false,
    ),
    BillModel(
      billId: 'BILL003',
      billName: 'Internet Bill',
      amount: 60.00,
      // issueDate: DateTime(2025, 10, 5),
      dueDate: DateTime(2025, 10, 22),
      expiryDate: DateTime(2025, 10, 27),
      isPaid: false,
    ),
    BillModel(
      billId: 'BILL004',
      billName: 'MANAGEMENT Bill',
      amount: 54626.75,
      // issueDate: DateTime(2025, 10, 1),
      dueDate: DateTime(2025, 11, 25),
      expiryDate: DateTime(2025, 11, 30),
      isPaid: false,
    ),
    BillModel(
      billId: 'BILL005',
      billName: 'BIKE INS Bill',
      amount: 54286.75,
      // issueDate: DateTime(2025, 10, 1),
      dueDate: DateTime(2025, 11, 20),
      expiryDate: DateTime(2025, 11, 30),
      isPaid: false,
    ),
    BillModel(
      billId: 'BILL006',
      billName: 'MOBILE Bill',
      amount: 3121325.75,
      // issueDate: DateTime(2025, 10, 1),
      dueDate: DateTime(2025, 12, 25),
      expiryDate: DateTime(2025, 12, 30),
      isPaid: false,
    ),
  ];

  /// Simulate fetching reminders from API
  Future<List<BillModel>> getMockReminders() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    return _mockReminders;
  }

  /// Simulate adding a reminder
  Future<void> addMockReminder(BillModel bill) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockReminders.add(bill);
  }

  /// Simulate removing a reminder
  Future<void> removeMockReminder(String billId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockReminders.removeWhere((r) => r.billId == billId);
  }

  /// Simulate clearing all reminders
  Future<void> clearMockReminders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockReminders.clear();
  }
}
