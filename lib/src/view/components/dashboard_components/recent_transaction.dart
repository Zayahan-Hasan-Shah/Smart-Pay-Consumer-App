import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/model/transaction_model/transaction_model.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RecentTransaction extends StatelessWidget {
  final TransactionModel transactions;
  const RecentTransaction({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1.h),
      decoration: BoxDecoration(
        color: AppColors.whiteBackgroundColor,
        border: Border.all(color: Colors.grey, width: 0.9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.arrow_back,
                  opticalSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 4.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildText(transactions.receiverAccountName, fontSize: 16.sp),
                  Row(
                    children: [
                      _buildText("K-ELECTRIC", fontSize: 14.sp),
                      SizedBox(width: 1.w),
                      _buildText("•", fontSize: 14.sp),
                      SizedBox(width: 1.w),
                      _buildText(transactions.time, fontSize: 14.sp),
                    ],
                  ),
                ],
              ),
            ],
          ),

          _buildText(
            transactions.amount.toString(),
            isAmount: true,
            fontSize: 16.sp,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildText(
    String text, {
    FontWeight weight = FontWeight.normal,
    double? fontSize,
    bool isAmount = false,
  }) {
    return isAmount
        ? TitleText(
            title: 'Rs.$text',
            weight: weight,
            fontSize: fontSize ?? 18.sp,
            color: AppColors.danger,
          )
        : TitleText(title: text, weight: weight, fontSize: fontSize ?? 18.sp);
  }
}
