import 'package:consumer_app/src/service/consumer_service/consumer_service.dart';
import 'package:get/get.dart';

class ConsumerNumberController extends GetxController {
  var isLoading = false.obs;

  Future<String?> consumerNumber(String consumerNumber) async {
    try {
      isLoading.value = true;
      dynamic response = await ConsumerService().createConsumerNumber(
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
}
