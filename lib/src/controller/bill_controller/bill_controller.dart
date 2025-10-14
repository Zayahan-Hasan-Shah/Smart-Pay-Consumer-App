import 'package:consumer_app/src/model/bill_model/bill_model.dart';
import 'package:consumer_app/src/service/bill_service/bill_service.dart';
import 'package:get/get.dart';

class BillController extends GetxController {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var bills = <BillModel>[].obs;

  final BillService _service = BillService();

  int currentPage = 1;
  bool hasNext = false;
  int? currentConsumerNumberId;

  Future<void> fetchBillsByConsumerId(
    int consumerNumberId, {
    bool refresh = true,
  }) async {
    try {
      if (refresh) {
        isLoading.value = true;
        bills.clear();
        currentPage = 1;
      } else {
        isLoadingMore.value = true;
      }

      currentConsumerNumberId = consumerNumberId;

      final response = await _service.fetchBillsByConsumerId(
        consumerNumberId: consumerNumberId,
        page: currentPage,
        pageSize: 10,
      );

      if (response != null) {
        final List<BillModel> fetchedBills =
            (response['bills'] as List<BillModel>);

        hasNext = response['hasNext'] ?? false;
        currentPage = response['page'] ?? 1;

        bills.addAll(fetchedBills);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch bills: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreBills() async {
    if (!hasNext || isLoadingMore.value) return;
    currentPage++;
    await fetchBillsByConsumerId(currentConsumerNumberId!, refresh: false);
  }
}
