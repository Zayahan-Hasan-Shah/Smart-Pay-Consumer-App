import 'dart:async';
import 'dart:developer';
import 'package:consumer_app/src/model/bill_model/bill_model.dart';

class BillService {
  Future<List<BillModel>?> fetchBillsByConsumer(String consumerNumber) async {

    try{
        
    } catch(e){
      log("failed to fetch bills by consumer number $e");
      return null;
    }

    await Future.delayed(const Duration(seconds: 1)); // simulate API delay

    // mock bills
    return [
      BillModel(
        billId: "BILL-001",
        billName: "Electricity",
        amount: 4500,
        issueDate: DateTime(2025, 9, 10),
        dueDate: DateTime(2025, 9, 25),
        expiryDate: DateTime(2025, 10, 5),
        isPaid: false,
      ),
      BillModel(
        billId: "BILL-002",
        billName: "Water",
        amount: 1200,
        issueDate: DateTime(2025, 9, 5),
        dueDate: DateTime(2025, 9, 20),
        expiryDate: DateTime(2025, 9, 30),
        isPaid: true,
      ),
      BillModel(
        billId: "BILL-003",
        billName: "Internet",
        amount: 2500,
        issueDate: DateTime(2025, 9, 8),
        dueDate: DateTime(2025, 9, 22),
        expiryDate: DateTime(2025, 10, 1),
        isPaid: false,
      ),
      BillModel(
        billId: "BILL-004",
        billName: "RENT",
        amount: 2500,
        issueDate: DateTime(2025, 9, 8),
        dueDate: DateTime(2025, 10, 22),
        expiryDate: DateTime(2025, 10, 30),
        isPaid: false,
      ),
    ];
  }
}
