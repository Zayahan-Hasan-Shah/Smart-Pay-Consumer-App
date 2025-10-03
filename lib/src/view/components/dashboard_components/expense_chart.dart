import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/model/dashboard_model/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpenseChart extends StatelessWidget {
  final DashboardModel data;
  const ExpenseChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(labelFormat: 'Rs{value}'),
        tooltipBehavior: TooltipBehavior(enable: true),
        enableAxisAnimation: true,
        plotAreaBorderWidth: 0,
        series: <CartesianSeries>[
          ColumnSeries<dynamic, String>(
            dataSource: data.monthlyExpenses,
            xValueMapper: (expense, _) => expense.month,
            yValueMapper: (expense, _) => expense.amount,
            color: AppColors.authButtonBakgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            width: 0.8,
            spacing: 0.05,
            name: "Expenses",
          ),
        ],
      ),
    );
  }
}
