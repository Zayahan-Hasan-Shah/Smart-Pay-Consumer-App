import 'dart:async';
import 'package:consumer_app/src/model/dashboard_model/dashboard_model.dart';

class DashboardService {
  Future<DashboardModel> fetchDashboardData() async {
    await Future.delayed(const Duration(seconds: 1));

    return DashboardModel(
      totalBills: 15000,
      totalPayments: 12000,
      pendingDues: 3000,
      billsData: [
        BillData("Paid", 12000),
        BillData("Unpaid", 2000),
        BillData("Pending", 1000),
      ],
      monthlyExpenses: [
        ExpenseData("Jan", 2000),
        ExpenseData("Feb", 1800),
        ExpenseData("Mar", 2200),
        ExpenseData("Apr", 1500),
        ExpenseData("May", 2400),
        ExpenseData("Jun", 2100),
      ],
      paymentHistory: [
        PaymentHistoryData("Jan", 1800, 200),
        PaymentHistoryData("Feb", 1500, 300),
        PaymentHistoryData("Mar", 2000, 200),
        PaymentHistoryData("Apr", 1200, 300),
        PaymentHistoryData("May", 2100, 300),
        PaymentHistoryData("Jun", 1900, 200),
      ],
    );
  }
}
