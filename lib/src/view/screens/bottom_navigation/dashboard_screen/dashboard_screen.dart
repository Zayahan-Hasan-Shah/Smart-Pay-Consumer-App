import 'package:consumer_app/src/controller/dashboard_controller/dashboard_controller.dart';
import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar( 
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text("Dashboard", style: theme.textTheme.titleMedium?.copyWith(color: theme.appBarTheme.foregroundColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.dashboardData.value == null) {
          return const Center(child: Text('No dashboard data available'));
        }

        final data = controller.dashboardData.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Overview Cards ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _overviewCard(
                    "Total Bills",
                    "Rs${data.totalBills}",
                    Icons.receipt_long,
                    Colors.orange,
                  ),
                  _overviewCard(
                    "Payments",
                    "Rs${data.totalPayments}",
                    Icons.check_circle,
                    Colors.green,
                  ),
                  _overviewCard(
                    "Pending",
                    "Rs${data.pendingDues}",
                    Icons.warning_amber,
                    Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Bills Chart ---
              Text(
                "Bills Overview",
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 250,
                child: SfCircularChart(
                  legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CircularSeries>[
                    DoughnutSeries<dynamic, String>(
                      dataSource: data.billsData,
                      xValueMapper: (bill, _) => bill.status,
                      yValueMapper: (bill, _) => bill.amount,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Monthly Expenses Chart ---
              Text(
                "Monthly Expenses",
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 250,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(labelFormat: 'Rs{value}'),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries>[
                    ColumnSeries<dynamic, String>(
                      dataSource: data.monthlyExpenses,
                      xValueMapper: (expense, _) => expense.month,
                      yValueMapper: (expense, _) => expense.amount,
                      color: AppColors.primaryColor,
                      name: "Expenses",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Payment History Chart ---
              Text(
                "Payment History",
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 280,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(labelFormat: 'Rs{value}'),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend: Legend(isVisible: true),
                  series: <CartesianSeries>[
                    LineSeries<dynamic, String>(
                      dataSource: data.paymentHistory,
                      xValueMapper: (p, _) => p.month,
                      yValueMapper: (p, _) => p.paid,
                      markerSettings: const MarkerSettings(isVisible: true),
                      color: Colors.green,
                      name: "Paid",
                    ),
                    LineSeries<dynamic, String>(
                      dataSource: data.paymentHistory,
                      xValueMapper: (p, _) => p.month,
                      yValueMapper: (p, _) => p.unpaid,
                      markerSettings: const MarkerSettings(isVisible: true),
                      color: Colors.red,
                      name: "Unpaid",
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _overviewCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: AppColors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
