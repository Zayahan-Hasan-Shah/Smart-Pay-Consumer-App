import 'dart:convert';
import 'package:consumer_app/src/model/consumer_model/consumer_model.dart';
import 'package:consumer_app/src/service/consumer_service/consumer_service.dart';
import 'package:consumer_app/src/service/storage_service/storage_services.dart';
import 'package:get/get.dart';

class ConsumerNumberController extends GetxController {
  var isLoading = false.obs;
  var consumerNumbers = <ConsumerModel>[].obs;

  Future<String?> consumerNumber(String consumerNumber) async {
    final userId = await StorageServices().read("user_id");

    try {
      isLoading.value = true;
      final response = await ConsumerService().createConsumerNumber(
        int.parse(userId!),
        consumerNumber,
      );

      if (response != null) {
        await getConsumerNumbrOfUser(userId!.toString());
      }
      return response;
    } catch (e) {
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getConsumerNumbrOfUser(String id) async {
    try {
      isLoading.value = true;
      var response = await ConsumerService().getConsumerNumbrOfUser(
        int.parse(id),
      );
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
