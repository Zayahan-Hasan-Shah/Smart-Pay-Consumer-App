class DashboardModel {
  final double totalBills;
  final double totalPayments;
  final double pendingDues;
  final List<BillData> billsData;
  final List<ExpenseData> monthlyExpenses;
  final List<PaymentHistoryData> paymentHistory;

  DashboardModel({
    required this.totalBills,
    required this.totalPayments,
    required this.pendingDues,
    required this.billsData,
    required this.monthlyExpenses,
    required this.paymentHistory,
  });
}

class BillData {
  final String status; // Paid, Unpaid, Pending
  final double amount;

  BillData(this.status, this.amount);
}

class ExpenseData {
  final String month;
  final double amount;

  ExpenseData(this.month, this.amount);
}

class PaymentHistoryData {
  final String month;
  final double paid;
  final double unpaid;

  PaymentHistoryData(this.month, this.paid, this.unpaid);
}
