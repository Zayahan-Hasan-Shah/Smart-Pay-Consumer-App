import 'package:consumer_app/src/model/transaction_model/transaction_model.dart';

final List<TransactionModel> dummyTransactions = [
  TransactionModel(
    transactionId: "T001",
    amount: 55.20,
    date: DateTime(2023, 10, 26),
    time: "10:30 AM",
    type: "Groceries",
    senderAccountName: "You",
    receiverAccountName: "SuperMart",
  ),
  TransactionModel(
    transactionId: "T002",
    amount: 2500.00,
    date: DateTime(2023, 10, 25),
    time: "04:15 PM",
    type: "Salary",
    senderAccountName: "Company Ltd.",
    receiverAccountName: "You",
  ),
  TransactionModel(
    transactionId: "T003",
    amount: 800.00,
    date: DateTime(2023, 10, 24),
    time: "09:00 AM",
    type: "Rent",
    senderAccountName: "You",
    receiverAccountName: "Landlord",
  ),
  TransactionModel(
    transactionId: "T004",
    amount: 75.50,
    date: DateTime(2023, 10, 23),
    time: "07:45 PM",
    type: "Utilities",
    senderAccountName: "You",
    receiverAccountName: "K-ELECTRIC",
  ),
];
