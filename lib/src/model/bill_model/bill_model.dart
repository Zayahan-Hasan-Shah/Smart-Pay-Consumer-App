class BillModel {
  final String billId;
  final String billName;
  final double amount;
  // final DateTime issueDate;
  final DateTime dueDate;
  final DateTime expiryDate;
  final bool isPaid;

  BillModel({
    required this.billId,
    required this.billName,
    required this.amount,
    // required this.issueDate,
    required this.dueDate,
    required this.expiryDate,
    required this.isPaid,
  });
}
