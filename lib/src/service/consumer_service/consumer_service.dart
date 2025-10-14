import 'dart:convert';
import 'dart:developer';

import 'package:consumer_app/src/core/constants/api_url.dart';
import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/model/consumer_model/consumer_model.dart';
import 'package:consumer_app/src/service/common_service/api_service.dart';
import 'package:get/get.dart';

class ConsumerService {
  Future<String?> createConsumerNumber(int id, String cNo) async {
    try {
      var bodySent = {"userId": id, "consumerNumber": cNo};
      var response = await APIService.post(
        api: ApiUrl.registerConsumerNoUrl,
        body: bodySent,
      );

      if (response != null) {
        Get.snackbar(
          "Successfull",
          "Consumer Number Registered",
          colorText: AppColors.white,
          backgroundColor: AppColors.primaryColor,
          snackPosition: SnackPosition.BOTTOM,
        );
        return response;
      }
      Get.snackbar(
        "Failed",
        "Failed to Register Consumer Number",
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

  Future<List<ConsumerModel>?> getConsumerNumbrOfUser(int userId) async {
    try {
      var response = await APIService.get(
        api: '${ApiUrl.getConsumerNoOfUser}$userId',
      );
      if (response != null) {
        final decoded = jsonDecode(response);
        final List<dynamic> list = decoded["consumerNumbers"];
        final consumers = list
            .map(
              (item) => ConsumerModel(
                consumerNumberId: item["consumerNumberId"],
                number: item["number"],
              ),
            )
            .toList();
        Get.snackbar(
          "Successfull",
          "Consumer Number Fetched",
          colorText: AppColors.white,
          backgroundColor: AppColors.primaryColor,
          snackPosition: SnackPosition.BOTTOM,
        );
        return consumers;
      }
      Get.snackbar(
        "Error",
        "Failed to Fetch Consumer Number",
        colorText: AppColors.white,
        backgroundColor: AppColors.danger,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } catch (e) {
      log("Error occur while fetching Consumer Number $e");
      return null;
    }
  }
}
