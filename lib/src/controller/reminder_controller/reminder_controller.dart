import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReminderController extends GetxController {
  var isReminderOn = false.obs;
  var reminderDate = Rxn<DateTime>();

  Future<void> toggleReminder(
    BuildContext context,
    bool value,
    DateTime billDueDate,
  ) async {
    if (value) {
      DateTime now = DateTime.now();

      //  If due date already passed
      if (billDueDate.isBefore(now)) {
        Get.snackbar(
          "Invalid Action",
          "This bill's due date has already passed.",
          snackPosition: SnackPosition.BOTTOM,
        );
        isReminderOn.value = false;
        return;
      }

      //  Safe range: today → due date
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: now.isBefore(billDueDate) ? now : billDueDate,
        firstDate: now,
        lastDate: billDueDate,
        helpText: "Select reminder date (before due date)",
      );

      if (selectedDate != null) {
        if (selectedDate.isAfter(billDueDate)) {
          Get.snackbar(
            "Invalid Date",
            "Reminder cannot be after the due date (${DateFormat('dd MMM, yyyy').format(billDueDate)})",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.danger,
            colorText: AppColors.white,
          );
          isReminderOn.value = false;
          return;
        }

        reminderDate.value = selectedDate;
        isReminderOn.value = true;

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
      Get.snackbar(
        "Reminder Cleared",
        "You’ve turned off the reminder",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
