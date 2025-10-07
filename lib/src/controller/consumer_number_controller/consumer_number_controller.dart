import 'dart:convert';
import 'package:consumer_app/src/model/consumer_model/consumer_model.dart';
import 'package:consumer_app/src/service/consumer_service/consumer_service.dart';
import 'package:consumer_app/src/service/storage_service/storage_services.dart';
import 'package:get/get.dart';

class ConsumerNumberController extends GetxController {
  var isLoading = false.obs;
  var consumerNumbers = <ConsumerModel>[].obs;

  Future<String?> consumerNumber(String consumerNumber) async {
    try {
      final user_info = await StorageServices().read("user_info");
      final userMap = user_info != null ? jsonDecode(user_info) : {"id": 1}; // mock user

      isLoading.value = true;
      dynamic response = await ConsumerService().createConsumerNumber(
        userMap['id'],
        consumerNumber,
      );

      if (response != null) {
        // refresh consumer numbers after successful registration
        isLoading.value = false;
        await getConsumerNumbrOfUser(userMap['id'].toString());
        return response;
      }
      return null;
    } catch (e) {
      isLoading.value = false;
      return null;
    }
  }

  Future<void> getConsumerNumbrOfUser(String id) async {
    try {
      isLoading.value = true;
      var response = await ConsumerService().getConsumerNumbrOfUser(int.parse(id));
      if (response != null) {
        consumerNumbers.assignAll(response);
      }
    } catch (e) {
      consumerNumbers.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
