import 'package:consumer_app/src/model/dashboard_model/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PaymentChart extends StatelessWidget {
  final DashboardModel data;
  const PaymentChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
