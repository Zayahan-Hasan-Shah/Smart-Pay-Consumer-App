import 'package:consumer_app/src/model/transaction_model/transaction_model.dart';
import 'package:consumer_app/src/service/transaction_service/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  var isLoading = false.obs;
  var transactions = <TransactionModel>[].obs;
  var selectedDateRange = Rxn<DateTimeRange>();
  var amountRange = Rx<RangeValues>(const RangeValues(0, 100000));

  final TransactionService _service = TransactionService();

  Future<void> fetchTransactions() async {
    try {
      isLoading.value = true;
      final fetched = await _service.fetchTransactions();
      transactions.value = fetched;
    } catch (e) {
      Get.snackbar("Error", "Failed to load transactions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void clearFilters() {
    selectedDateRange.value = null;
    amountRange.value = const RangeValues(0, 100000);
  }

  List<TransactionModel> get filteredTransactions {
    final range = selectedDateRange.value;
    final RangeValues ar = amountRange.value;
    return transactions.where((txn) {
      final inDateRange =
          range == null ||
          (!txn.date.isBefore(range.start) && !txn.date.isAfter(range.end));
      final inAmountRange = txn.amount >= ar.start && txn.amount <= ar.end;
      return inDateRange && inAmountRange;
    }).toList();
  }
}
