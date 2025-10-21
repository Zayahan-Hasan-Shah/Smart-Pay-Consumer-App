import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/core/utils/global.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ReminderComponents extends StatelessWidget {
  const ReminderComponents({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.5.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                //  allows wrapping
                child: _buildText(
                  "ELECTRICITY BILL",
                  fontSize: 18.sp,
                  weight: FontWeight.w600,
                ),
              ),
              _buildText(
                "20 oct, 2025",
                // formatDate(bill.dueDate),
                fontSize: 15.sp,
                weight: FontWeight.w400,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildText(
                formatAmountPKR(456000),
                fontSize: 22.sp,
                weight: FontWeight.w600,
              ),
              _buildIsPaid(false),
            ],
          ),

          SizedBox(height: 2.h),
          Divider(color: AppColors.grey.withOpacity(0.4), height: 2.h),

          // SwitchListTile(
          //     contentPadding: EdgeInsets.zero,
          //     title: const TitleText(title: "Set Reminder"),
          //     value: controller.isReminderOn.value,
          //     onChanged: (value) =>
          //         controller.toggleReminder(context, value, bill.dueDate),
          //     secondary: Icon(Icons.alarm, color: AppColors.info),
          //   ),

          //    if (controller.reminderDate.value != null)
          //     Padding(
          //       padding: EdgeInsets.only(left: 1.h, top: 0.5.h),

          //       child: TitleText(
          //         title:
          //             "Reminder: ${formatDate(controller.reminderDate.value!)}",
          //         fontSize: 18.sp,
          //         color: AppColors.info,
          //         weight: FontWeight.bold,
          //       ),
          //       // child: Text(
          //       //   "Reminder: ${formatDate(controller.reminderDate.value!)}",
          //       //   style: TextStyle(color: AppColors.info, fontSize: 14.sp),
          //       // ),
          //     ),
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
      overflow: shouldWrap
          ? TextOverflow.ellipsis
          : TextOverflow.visible, // ✅ let it wrap instead of cutting
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
