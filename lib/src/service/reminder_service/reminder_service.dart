import 'package:consumer_app/src/model/bill_model/bill_model.dart';

class ReminderService {
  // Mock in-memory data list
  final List<BillModel> _mockReminders = [
    BillModel(
      billId: 'BILL001',
      billName: 'Electricity Bill',
      amount: 125.75,
      issueDate: DateTime(2025, 10, 1),
      dueDate: DateTime(2025, 10, 25),
      expiryDate: DateTime(2025, 10, 30),
      isPaid: false,
    ),
    BillModel(
      billId: 'BILL002',
      billName: 'Water Bill',
      amount: 45.50,
      issueDate: DateTime(2025, 9, 28),
      dueDate: DateTime(2025, 10, 20),
      expiryDate: DateTime(2025, 10, 25),
      isPaid: false,
    ),
    BillModel(
      billId: 'BILL003',
      billName: 'Internet Bill',
      amount: 60.00,
      issueDate: DateTime(2025, 10, 5),
      dueDate: DateTime(2025, 10, 22),
      expiryDate: DateTime(2025, 10, 27),
      isPaid: false,
    ),
  ];

  /// Simulate fetching reminders from API
  Future<List<BillModel>> getMockReminders() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    return _mockReminders;
  }

  /// Simulate adding a reminder
  Future<void> addMockReminder(BillModel bill) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockReminders.add(bill);
  }

  /// Simulate removing a reminder
  Future<void> removeMockReminder(String billId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockReminders.removeWhere((r) => r.billId == billId);
  }

  /// Simulate clearing all reminders
  Future<void> clearMockReminders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockReminders.clear();
  }
}
