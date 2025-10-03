import 'package:consumer_app/src/controller/dashboard_controller/dashboard_controller.dart';
import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/core/constants/dummy_data/recent_transaction_dummy_data.dart';
import 'package:consumer_app/src/view/components/common_components/custom_appbar.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:consumer_app/src/view/components/dashboard_components/expense_chart.dart';
import 'package:consumer_app/src/view/components/dashboard_components/overview_card.dart';
import 'package:consumer_app/src/view/components/dashboard_components/payment_chart.dart';
import 'package:consumer_app/src/view/components/dashboard_components/recent_transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(title: "Dashboard", isnotify: true),
      // appBar: AppBar(
      //   backgroundColor: theme.appBarTheme.backgroundColor,
      //   title: Text("Dashboard", style: theme.textTheme.titleMedium?.copyWith(color: theme.appBarTheme.foregroundColor, fontWeight: FontWeight.bold)),
      //   centerTitle: true,
      // ),
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
                    "${data.totalBills}",
                    Icons.receipt_long,
                    Colors.orange,
                  ),
                  _overviewCard(
                    "Piad",
                    "${data.totalPayments}",
                    Icons.check_circle,
                    Colors.green,
                  ),
                  _overviewCard(
                    "Pending",
                    "${data.pendingDues}",
                    Icons.warning_amber,
                    Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Bills Chart ---
              // Text("Bills Overview", style: theme.textTheme.titleMedium),
              // const SizedBox(height: 12),
              // SizedBox(
              //   height: 250,
              //   child: SfCircularChart(
              //     legend: Legend(
              //       isVisible: true,
              //       overflowMode: LegendItemOverflowMode.wrap,
              //     ),
              //     tooltipBehavior: TooltipBehavior(enable: true),
              //     series: <CircularSeries>[
              //       DoughnutSeries<dynamic, String>(
              //         dataSource: data.billsData,
              //         xValueMapper: (bill, _) => bill.status,
              //         yValueMapper: (bill, _) => bill.amount,
              //         dataLabelSettings: const DataLabelSettings(
              //           isVisible: true,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 20),

              // --- Monthly Expenses Chart ---
              Text("Expenses", style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              ExpenseChart(data: data),
              const SizedBox(height: 20),

              // --- Payment History Chart ---
              Text("Payment History", style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              PaymentChart(data: data),

              // --- Recent Transaction ---
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: AppColors.recentTransactionBackgroundColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleText(title: "Recent Transactions", fontSize: 18.sp),
                    TextButton(
                      onPressed: () {},
                      child: TitleText(
                        title: "View All",
                        fontSize: 16.sp,
                        color: AppColors.authButtonBakgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: dummyTransactions
                        .map(
                          (txn) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: RecentTransaction(transactions: txn),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _overviewCard(String title, String value, IconData icon, Color color) {
    return OverviewCard(title: title, value: value, icon: icon, color: color);
  }
}
