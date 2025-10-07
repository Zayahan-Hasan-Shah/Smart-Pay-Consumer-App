import 'package:consumer_app/src/model/bill_model/bill_model.dart';
import 'package:consumer_app/src/service/bill_service/bill_service.dart';
import 'package:get/get.dart';

class BillController extends GetxController {
  var isLoading = false.obs;
  var bills = <BillModel>[].obs;

  final BillService _service = BillService();

  Future<void> fetchBills(String consumerNumber) async {
    try {
      isLoading.value = true;
      final fetchedBills = await _service.fetchBillsByConsumer(consumerNumber);
      if (fetchedBills != null) {
        bills.assignAll(fetchedBills);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch bills: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
