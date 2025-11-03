// import 'package:consumer_app/src/model/bill_model/bill_model.dart';
// import 'package:consumer_app/src/service/reminder_service/reminder_service.dart';
// import 'package:consumer_app/src/view/components/common_components/custom_appbar.dart';
// import 'package:consumer_app/src/view/components/bill_components/bill_list_component.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// class ReminderScreen extends StatefulWidget {
//   const ReminderScreen({super.key});

//   @override
//   State<ReminderScreen> createState() => _ReminderScreenState();
// }

// class _ReminderScreenState extends State<ReminderScreen> {
//   final ReminderService _service = ReminderService();
//   List<BillModel> _reminderBills = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadReminders();
//   }

//   Future<void> _loadReminders() async {
//     final data = await _service.getMockReminders();
//     setState(() {
//       _reminderBills = data;
//       _loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppbar(title: "Reminders", isnotify: false, isback: true),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(2.h),
//           child: _loading
//               ? const Center(child: CircularProgressIndicator())
//               : _reminderBills.isEmpty
//               ? const Center(child: Text("No reminders set yet"))
//               : RefreshIndicator(
//                   onRefresh: _loadReminders,
//                   child: ListView.builder(
//                     itemCount: _reminderBills.length,
//                     itemBuilder: (context, index) {
//                       final bill = _reminderBills[index];
//                       return Padding(
//                         padding: EdgeInsets.only(bottom: 1.5.h),
//                         child: BillListComponent(bill: bill, consumerNumberId: bill.,),
//                       );
//                     },
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }
