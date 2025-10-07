import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/core/utils/global.dart';
import 'package:consumer_app/src/model/transaction_model/transaction_model.dart';
import 'package:consumer_app/src/routes/route_names.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel txn;
  const TransactionCard({super.key, required this.txn});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteNames.transactionDetailScreen, arguments: txn);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          // color: Get.theme.colorScheme.surface,
          // gradient: AppColors.successGradient,
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 0.5,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _textBuild(
              txn.transactionId,
              color: AppColors.authButtonBakgroundColor,
              fontSize: 16.sp,
            ),
            SizedBox(height: 0.7.h),
            // Amount + Type Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _textBuild(
                  formatAmountPKR(txn.amount),
                  color: Get.theme.colorScheme.onSurface,
                  weight: FontWeight.bold,
                  fontSize: 22,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.authButtonBakgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    txn.type,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Sender + Receiver
            _textBuild(
              "From: ${txn.senderAccountName}",
              color: Get.theme.colorScheme.onSurface,
              fontSize: 16,
            ),
            _textBuild(
              "To: ${txn.receiverAccountName}",
              color: Get.theme.colorScheme.onSurface,
              fontSize: 16,
            ),
            const SizedBox(height: 10),

            // Date + Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _textBuild(
                  "${txn.date.day}/${txn.date.month}/${txn.date.year}",
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.9),
                  fontSize: 14,
                ),
                _textBuild(
                  txn.time,
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TitleText _textBuild(
    String text, {
    Color? color,
    double? fontSize,
    FontWeight? weight,
  }) {
    return TitleText(
      title: text,
      fontSize: fontSize ?? 16,
      color: color ?? Colors.black,
      weight: weight ?? FontWeight.w500,
    );
  }
}
