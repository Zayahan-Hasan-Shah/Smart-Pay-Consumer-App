import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/core/utils/global.dart';
import 'package:consumer_app/src/model/bill_model/bill_model.dart';
import 'package:consumer_app/src/view/components/common_components/custom_appbar.dart';
import 'package:consumer_app/src/view/components/common_components/fractionally_elevated_button.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart'; // Add iconsax package for sexy icons

class BillDetailScreen extends StatelessWidget {
  const BillDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BillModel bill = Get.arguments as BillModel;
    final isOverdue = !bill.isPaid && DateTime.now().isAfter(bill.dueDate);

    final theme = Theme.of(context);
    return Scaffold(
      // backgroundColor: theme.appBarTheme.backgroundColor,
      appBar: CustomAppbar(title: "Bill Detail", isnotify: false, isback: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(3.h),
        child: Column(
          children: [
            _buildText(bill.billId, fontSize: 18.sp, color: theme.appBarTheme.foregroundColor),
            SizedBox(height: 1.5.h),
            _buildRow(
              bill.billName,
              bill.isPaid,
              isStatus: true,
              color1: theme.appBarTheme.foregroundColor,
            ),

            Divider(
              color: theme.appBarTheme.foregroundColor!.withOpacity(0.4),
              height: 2.h,
            ),
            _buildRow(
              "Bill Amount",
              "Issue Date",
              fontSize1: 15.sp,
              fontSize2: 15.sp,
              color1: theme.appBarTheme.foregroundColor,
              color2: theme.appBarTheme.foregroundColor,
            ),
            SizedBox(height: 1.h),
            _buildRow(
              bill.amount,
              bill.issueDate,
              fontSize1: 18.sp,
              fontSize2: 18.sp,
              isAmount: true,
              isDate: true,
              color1: theme.appBarTheme.foregroundColor,
              color2: theme.appBarTheme.foregroundColor,
            ),
            SizedBox(height: 2.5.h),
            _buildRow(
              "Due Date",
              "Expiration Date",
              fontSize1: 15.sp,
              fontSize2: 15.sp,
              color1: theme.appBarTheme.foregroundColor,
              color2: theme.appBarTheme.foregroundColor,
            ),
            SizedBox(height: 1.h),
            _buildRow(
              bill.dueDate,
              bill.expiryDate,
              fontSize1: 18.sp,
              fontSize2: 18.sp,
              isBothDate: true,
              color1: theme.appBarTheme.foregroundColor,
              color2: theme.appBarTheme.foregroundColor,
            ),

            SizedBox(height: 4.h),

            bill.isPaid
                ? Column(
                    children: [
                      const Icon(
                        Iconsax.tick_circle,
                        color: Colors.green,
                        size: 60,
                      ),
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
                : Center(
                    child: FractionallyElevatedButton(
                      onTap: () {
                        Get.snackbar(
                          "Payment",
                          "Bill paid successfully!",
                          backgroundColor: AppColors.success,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      backgroundColor: isOverdue
                          ? AppColors.danger
                          : AppColors.authButtonBakgroundColor,
                      child: TitleText(
                        title: isOverdue ? "PAY OVERDUE" : "PAY NOW",
                        fontSize: 20,
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildText(
    String title, {
    double? fontSize,
    Color? color,
    FontWeight? weight,
  }) {
    return TitleText(
      title: title,
      fontSize: fontSize ?? 16.sp,
      color: color ?? Colors.black,
      weight: weight ?? FontWeight.normal,
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
        fontSize: 15.sp,
        weight: FontWeight.w600,
      ),
    );
  }

  Widget _buildRow(
    dynamic text1,
    dynamic text2, {
    bool isDate = false,
    bool isAmount = false,
    Color? color1 = Colors.black,
    Color? color2 = Colors.black,
    double? fontSize1 = 16,
    double? fontSize2 = 16,
    bool isStatus = false,
    bool isBothDate = false,
  }) {
    if (isDate && isAmount) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildText(
            formatAmountPKR(text1),
            fontSize: fontSize1 ?? 18.sp,
            color: color1,
          ),
          _buildText(
            formatDate(text2),
            fontSize: fontSize2 ?? 18.sp,
            color: color2,
          ),
        ],
      );
    } else if (isDate) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildText(text1, fontSize: fontSize1 ?? 18.sp, color: color1),
          _buildText(
            formatDate(text2),
            fontSize: fontSize2 ?? 18.sp,
            color: color2,
          ),
        ],
      );
    } else if (isAmount) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildText(
            formatAmountPKR(text1),
            fontSize: fontSize1 ?? 18.sp,
            color: color1,
          ),
          _buildText(text2, fontSize: fontSize2 ?? 18.sp, color: color2),
        ],
      );
    } else if (isStatus) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildText(
            text1,
            fontSize: 22.sp,
            weight: FontWeight.w600,
            color: color1,
          ),
          _buildIsPaid(text2),
        ],
      );
    } else if (isBothDate) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildText(
            formatDate(text1),
            fontSize: fontSize2 ?? 18.sp,
            color: color1,
          ),
          _buildText(
            formatDate(text2),
            fontSize: fontSize2 ?? 18.sp,
            color: color2,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildText(text1, fontSize: fontSize1 ?? 18.sp, color: color1),
          _buildText(text2, fontSize: fontSize2 ?? 18.sp, color: color2),
        ],
      );
    }
  }
}
