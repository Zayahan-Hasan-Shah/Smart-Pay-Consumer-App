import 'dart:convert';
import 'dart:developer';
import 'package:consumer_app/src/core/constants/api_url.dart';
import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/model/bill_model/bill_model.dart';
import 'package:consumer_app/src/service/common_service/api_service.dart';
import 'package:get/get.dart';

class BillService {
  Future<Map<String, dynamic>?> fetchBillsByConsumerId({
    required int consumerNumberId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await APIService.get(
        api:
            '${ApiUrl.getBillsByConsumerNoUrl}$consumerNumberId?page=$page&pageSize=$pageSize',
      );

      if (response != null) {
        final decoded = jsonDecode(response);
        final List<dynamic> items = decoded['items'] ?? [];

        final bills = items.map((item) {
          return BillModel(
            billId: item['billId'].toString(),
            billName: item['billName'] ?? 'N/A',
            amount: (item['amount'] as num?)?.toDouble() ?? 0.0,
            // issueDate: DateTime.parse(item['issueDate']),
            dueDate: DateTime.parse(item['dueDate']),
            expiryDate: DateTime.parse(item['expiryDate']),
            isPaid: item['isPaid'] ?? false,
          );
        }).toList();

        return {
          'bills': bills,
          'hasNext': decoded['hasNext'] ?? false,
          'page': decoded['page'] ?? 1,
          'totalPages': decoded['totalPages'] ?? 1,
        };
      }
      log("Failed to Fetch bills");
      Get.snackbar(
        "Failed",
        "Failed to Fetch Bills",
        colorText: AppColors.white,
        backgroundColor: AppColors.danger,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } catch (e) {
      log("Failed to fetch bills by consumer ID: $e");
      return null;
    }
  }
}
