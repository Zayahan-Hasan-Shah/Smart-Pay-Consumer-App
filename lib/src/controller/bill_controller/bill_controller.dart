import 'package:consumer_app/src/controller/reminder_controller/reminder_controller.dart';
import 'package:consumer_app/src/model/bill_model/bill_model.dart';
import 'package:consumer_app/src/service/bill_service/bill_service.dart';
import 'package:get/get.dart';

enum BillFilterType { dueDate, paid, unpaid, reminder }

class BillController extends GetxController {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var bills = <BillModel>[].obs;
  var filteredBills = <BillModel>[].obs;
  var selectedFilters = <BillFilterType>[].obs;

  final BillService _service = BillService();

  int currentPage = 1;
  bool hasNext = false;
  int? currentConsumerNumberId;

  /// Fetch bills from API
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

        if (refresh) {
          bills.assignAll(fetchedBills);
        } else {
          bills.addAll(fetchedBills);
        }

        // When new bills come in, apply filters if active
        applyFilters();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch bills: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Load next page
  Future<void> loadMoreBills() async {
    if (!hasNext || isLoadingMore.value) return;

    currentPage++;
    await fetchBillsByConsumerId(currentConsumerNumberId!, refresh: false);
  }

  /// Apply selected filters
  void applyFilters() {
    List<BillModel> result = List.from(bills);

    for (var filter in selectedFilters) {
      switch (filter) {
        case BillFilterType.paid:
          result = result.where((b) => b.isPaid).toList();
          break;
        case BillFilterType.unpaid:
          result = result.where((b) => !b.isPaid).toList();
          break;
        case BillFilterType.dueDate:
          result.sort((a, b) => a.dueDate.compareTo(b.dueDate));
          break;
        case BillFilterType.reminder:
          final reminderControllers = ReminderController.allControllers;
          final reminderBillIds = reminderControllers
              .where((c) => c.reminderDate.value != null)
              .map((c) => c.billId)
              .toList();

          result = result
              .where((b) => reminderBillIds.contains(b.billId))
              .toList();
          break;
      }
    }

    filteredBills.assignAll(result);
  }

  void clearFilters() {
    selectedFilters.clear();
    filteredBills.assignAll(bills);
  }

  void toggleFilter(BillFilterType type) {
    if (selectedFilters.contains(type)) {
      selectedFilters.remove(type);
    } else {
      selectedFilters.add(type);
    }
    applyFilters();
  }
}
