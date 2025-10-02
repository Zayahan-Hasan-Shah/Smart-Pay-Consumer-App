import 'package:consumer_app/src/controller/bill_controller/bill_controller.dart';
import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/model/user_model/user_model.dart';
import 'package:consumer_app/src/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillScreen extends StatelessWidget {
  const BillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BillController());

    // Suppose user model is already fetched after login
    final user = UserModel(
      id: 1,
      name: "Zayahan",
      email: "zayahan@gmail.com",
      phoneNumber: "923327699137",
      consumerNumber: "60054250180883267",
    );

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 6,
        shadowColor: theme.shadowColor,
        backgroundColor: theme.appBarTheme.backgroundColor,
        centerTitle: true,
        title: Text(
          "💡 Bills",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: theme.appBarTheme.foregroundColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            // Consumer Number field (frozen)
            TextField(
              controller: TextEditingController(text: user.consumerNumber),
              readOnly: true,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
              decoration: InputDecoration(
                labelText: "Consumer Number",
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                prefixIcon: Icon(
                  Icons.confirmation_number_outlined,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Fetch button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}) ?? theme.colorScheme.primary,
                  foregroundColor: theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}) ?? theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  controller.fetchBills(user.consumerNumber);
                },
                icon: Icon(Icons.cloud_download, color: theme.colorScheme.onPrimary),
                label: Text(
                  "Fetch Bills",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bill list
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.bills.isEmpty) {
                  return Center(
                    child: Text(
                      "No bills found 🥲",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.bills.length,
                  itemBuilder: (context, index) {
                    final bill = controller.bills[index];
                    return _billCard(bill);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billCard(bill) {
    final isOverdue = !bill.isPaid && DateTime.now().isAfter(bill.dueDate);

    Gradient statusGradient;
    String statusText;

    if (bill.isPaid) {
      statusGradient = const LinearGradient(
        colors: [Color(0xff4ade80), Color(0xff16a34a)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      statusText = "Paid ✅";
    } else if (isOverdue) {
      statusGradient = AppColors.dangerGradient;
      statusText = "Overdue ⏰";
    } else {
      statusGradient = AppColors.warningGradient;
      statusText = "Unpaid ⚠️";
    }

    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteNames.billDetailScreen, arguments: bill);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: AppColors.successGradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bill.billName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: statusGradient,
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Amount
            Text(
              "Amount: Rs ${bill.amount}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            // Dates
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _dateChip("Issue", bill.issueDate, AppColors.info),
                _dateChip("Due", bill.dueDate, AppColors.warning),
                _dateChip("Expiry", bill.expiryDate, AppColors.danger),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateChip(String label, DateTime date, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "$label: ${_formatDate(date)}",
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
