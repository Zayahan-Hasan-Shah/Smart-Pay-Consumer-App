import 'package:consumer_app/src/model/transaction_model/transaction_model.dart';

class TransactionService {
  Future<List<TransactionModel>> fetchTransactions() async {
    await Future.delayed(const Duration(seconds: 1)); // mock delay
    return [
      TransactionModel(
        transactionId: "TXN12345",
        amount: 5000,
        date: DateTime.now().subtract(const Duration(days: 1)),
        time: "10:45 AM",
        type: "Raast",
        senderAccountName: "Zayahan",
        receiverAccountName: "Ali Khan",
      ),
      TransactionModel(
        transactionId: "TXN67890",
        amount: 12000,
        date: DateTime.now().subtract(const Duration(days: 3)),
        time: "03:30 PM",
        type: "Bank Transfer",
        senderAccountName: "Zayahan",
        receiverAccountName: "HBL Loan",
      ),
    ];
  }
}
