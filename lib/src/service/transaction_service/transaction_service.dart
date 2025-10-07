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
      TransactionModel(
        transactionId: "TXN67891",
        amount: 120000,
        date: DateTime.now().subtract(const Duration(days: 3)),
        time: "04:33 PM",
        type: "Bank Transfer",
        senderAccountName: "Zayahan",
        receiverAccountName: "Okasha",
      ),
      TransactionModel(
        transactionId: "TXN67892",
        amount: 93000,
        date: DateTime.now().subtract(const Duration(days: 3)),
        time: "01:30 AM",
        type: "B2B",
        senderAccountName: "Zayahan",
        receiverAccountName: "Zia",
      ),
      TransactionModel(
        transactionId: "TXN67893",
        amount: 42400,
        date: DateTime.now().subtract(const Duration(days: 3)),
        time: "17:30 PM",
        type: "P2P",
        senderAccountName: "Zayahan",
        receiverAccountName: "GAMINGZONE",
      ),
    ];
  }
}
