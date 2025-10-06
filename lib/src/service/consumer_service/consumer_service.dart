import 'dart:developer';

import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/service/common_service/api_service.dart';
import 'package:get/get.dart';

class ConsumerService {
  Future<String?> createConsumerNumber(String cNo) async {
    try {
      var bodySent = {"consumerNuber": cNo};
      var response = await APIService.post(api: "", body: bodySent);
      if (response != null) {
        if (response.statusCode == 200) {
          Get.snackbar(
            "Successfull",
            "Consumer Number Registered",
            colorText: AppColors.white,
            backgroundColor: AppColors.primaryColor,
            snackPosition: SnackPosition.BOTTOM,
          );
          return response.body;
        }
      }
      Get.snackbar(
        "Error",
        "Consumer Number Didn't Registered",
        colorText: AppColors.white,
        backgroundColor: AppColors.danger,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } catch (e) {
      log("Error occur while creating Consumer Number $e");
      return null;
    }
  }
}
