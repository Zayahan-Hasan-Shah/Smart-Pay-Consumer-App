import 'dart:convert';
import 'dart:developer';

import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/model/consumer_model/consumer_model.dart';
import 'package:consumer_app/src/service/common_service/api_service.dart';
import 'package:get/get.dart';

class ConsumerService {
  Future<String?> createConsumerNumber(int id, String cNo) async {
    try {
      // var bodySent = {"userId": id, "consumerNuber": cNo};
      // var response = await APIService.post(api: "", body: bodySent);
      if (cNo == "60054250180883267") {
        Get.snackbar(
          "Successfull",
          "Consumer Number Registered",
          colorText: AppColors.white,
          backgroundColor: AppColors.primaryColor,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      // if (response != null) {
      //   if (response.statusCode == 200) {
      //     Get.snackbar(
      //       "Successfull",
      //       "Consumer Number Registered",
      //       colorText: AppColors.white,
      //       backgroundColor: AppColors.primaryColor,
      //       snackPosition: SnackPosition.BOTTOM,
      //     );
      //     return response.body;
      //   }
      // }
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

  Future<List<ConsumerModel>?> getConsumerNumbrOfUser() async {
    try {
      Get.snackbar(
        "Error",
        "Failed to Fetch Consumer Number",
        colorText: AppColors.white,
        backgroundColor: AppColors.danger,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      log("Error occur while fetching Consumer Number $e");
      return null;
    }
  }
}
