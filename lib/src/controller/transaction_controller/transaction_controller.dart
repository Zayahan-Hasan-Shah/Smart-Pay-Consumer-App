import 'package:consumer_app/src/model/transaction_model/transaction_model.dart';
import 'package:consumer_app/src/service/transaction_service/transaction_service.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  var isLoading = false.obs;
  var transactions = <TransactionModel>[].obs;

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
}
