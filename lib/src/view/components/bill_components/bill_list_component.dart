import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/core/utils/global.dart';
import 'package:consumer_app/src/controller/reminder_controller/reminder_controller.dart';
import 'package:consumer_app/src/model/bill_model/bill_model.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BillListComponent extends StatelessWidget {
  final BillModel bill;
  final ReminderController reminderController = Get.put(ReminderController());

  BillListComponent({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        // color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Header Row (Bill Name + Due Date) =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                // ✅ allows wrapping
                child: _buildText(
                  bill.billName,
                  fontSize: 18.sp,
                  weight: FontWeight.w600,
                ),
              ),
              _buildText(
                formatDate(bill.dueDate),
                fontSize: 15.sp,
                weight: FontWeight.w400,
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // ===== Amount + Paid Status =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildText(
                formatAmountPKR(bill.amount),
                fontSize: 22.sp,
                weight: FontWeight.w600,
              ),
              _buildIsPaid(bill.isPaid),
            ],
          ),

          SizedBox(height: 2.h),
          Divider(color: AppColors.grey.withOpacity(0.4), height: 2.h),

          // ===== Reminder Switch =====
          Obx(() {
            return SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const TitleText(title: "Set Reminder"),
              value: reminderController.isReminderOn.value,
              onChanged: (value) => reminderController.toggleReminder(
                context,
                value,
                bill.dueDate,
              ),
              secondary: Icon(Icons.alarm, color: AppColors.info),
            );
          }),

          // ===== Show reminder date (if any) =====
          Obx(() {
            if (reminderController.reminderDate.value == null) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: EdgeInsets.only(left: 1.h, top: 0.5.h),
              child: Text(
                "Reminder: ${formatDate(reminderController.reminderDate.value!)}",
                style: TextStyle(color: AppColors.info, fontSize: 12.sp),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildText(
    String title, {
    double? fontSize,
    Color? color,
    FontWeight? weight,
  }) {
    // Check if bill name length is greater than 12 → allow 2 lines
    final bool shouldWrap = title.length > 12;

    return TitleText(
      title: title,
      fontSize: fontSize ?? 16.sp,
      color: color ?? Colors.black,
      weight: weight ?? FontWeight.normal,
      maxLines: shouldWrap ? 2 : 1, // ✅ two lines if length > 12
      overflow: shouldWrap ? TextOverflow.ellipsis : TextOverflow.visible, // ✅ let it wrap instead of cutting
    );
  }

  Widget _buildIsPaid(bool isPaid) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 2.h),
      decoration: BoxDecoration(
        color: isPaid ? AppColors.primaryColor : AppColors.danger,
        borderRadius: BorderRadius.circular(12),
      ),
      child: _buildText(
        isPaid ? "Paid" : "UnPaid",
        color: AppColors.backgroundColor,
        fontSize: 12.sp,
        weight: FontWeight.w600,
      ),
    );
  }
}
