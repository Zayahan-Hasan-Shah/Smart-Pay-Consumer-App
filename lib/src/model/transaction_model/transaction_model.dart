class TransactionModel {
  final String transactionId;
  final double amount;
  final DateTime date;
  final String time;
  final String type; // e.g. Raast, Bank Transfer, etc.
  final String senderAccountName;
  final String receiverAccountName;

  TransactionModel({
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.time,
    required this.type,
    required this.senderAccountName,
    required this.receiverAccountName,
  });
}
