import 'dart:convert';

import 'package:consumer_app/src/model/consumer_model/consumer_model.dart';
import 'package:consumer_app/src/service/consumer_service/consumer_service.dart';
import 'package:consumer_app/src/service/storage_service/storage_services.dart';
import 'package:get/get.dart';

class ConsumerNumberController extends GetxController {
  var isLoading = false.obs;

  Future<String?> consumerNumber(String consumerNumber) async {
    try {
      final user_info = await StorageServices().read("user_info");
      final userMap = user_info != null ? jsonDecode(user_info) : null;

      isLoading.value = true;
      dynamic response = await ConsumerService().createConsumerNumber(
        userMap?['id'],
        consumerNumber,
      );
      if (response != null) {
        isLoading.value = false;
        return response;
      }
      return null;
    } catch (e) {
      isLoading.value = false;
      return null;
    }
  }

  Future<List<ConsumerModel>?> getConsumerNumbrOfUser(String id) async {
    try {
      isLoading.value = true;
      final user_info = await StorageServices().read("user_info");
      final userMap = user_info != null ? jsonDecode(user_info) : null;
      var response = await ConsumerService().getConsumerNumbrOfUser(userMap);
      if (response != null) {
        isLoading.value = false;

        return response;
      }
    } catch (e) {
      isLoading.value = false;
      return null;
    }
  }
}
