import 'package:consumer_app/src/model/dashboard_model/dashboard_model.dart';
import 'package:consumer_app/src/service/dashboard_service/dashboard_service.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;
  var dashboardData = Rxn<DashboardModel>();

  final DashboardService _service = DashboardService();

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  void fetchDashboardData() async {
    try {
      isLoading.value = true;
      final data = await _service.fetchDashboardData();
      dashboardData.value = data;
    } finally {
      isLoading.value = false;
    }
  }
}
