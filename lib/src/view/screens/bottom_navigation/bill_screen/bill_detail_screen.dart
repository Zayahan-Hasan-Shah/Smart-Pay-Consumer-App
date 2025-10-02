import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/model/bill_model/bill_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart'; // Add iconsax package for sexy icons

class BillDetailScreen extends StatelessWidget {
  const BillDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BillModel bill = Get.arguments as BillModel;
    final isOverdue = !bill.isPaid && DateTime.now().isAfter(bill.dueDate);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // 🔥 Top Gradient Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 40),
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.primaryColor.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  bill.billName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Rs ${bill.amount}",
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  bill.isPaid ? "This bill is already paid" : (isOverdue ? "Overdue Bill" : "Pending Payment"),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔥 Bill Details Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _infoRow(context, Iconsax.receipt, "Bill ID", bill.billId.toString()),
                    _infoRow(context, Iconsax.calendar, "Issue Date", _formatDate(bill.issueDate)),
                    _infoRow(context, Iconsax.timer, "Due Date", _formatDate(bill.dueDate)),
                    _infoRow(context, Iconsax.calendar_tick, "Expiry Date", _formatDate(bill.expiryDate)),
                    const Spacer(),

                    // 🔥 Payment Action
                    bill.isPaid
                        ? Column(
                            children: [
                              const Icon(Iconsax.tick_circle, color: Colors.green, size: 60),
                              const SizedBox(height: 8),
                              const Text(
                                "PAID",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          )
                        : ElevatedButton(
                            onPressed: () {
                              Get.snackbar("Payment", "Bill paid successfully!",
                                  backgroundColor: AppColors.success, colorText: Colors.white);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isOverdue ? AppColors.danger : AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 6,
                            ),
                            child: Text(
                              isOverdue ? "Pay Overdue" : "Pay Now",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            value,
            style:  TextStyle(
              color: Theme.of(context).textTheme.bodyMedium!.color,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
