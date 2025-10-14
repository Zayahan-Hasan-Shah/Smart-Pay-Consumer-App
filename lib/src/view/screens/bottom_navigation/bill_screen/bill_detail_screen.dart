// import 'package:consumer_app/src/core/constants/app_colors.dart';
// import 'package:consumer_app/src/core/utils/global.dart';
// import 'package:consumer_app/src/model/bill_model/bill_model.dart';
// import 'package:consumer_app/src/view/components/common_components/custom_appbar.dart';
// import 'package:consumer_app/src/view/components/common_components/fractionally_elevated_button.dart';
// import 'package:consumer_app/src/view/components/common_components/title_text.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:sizer/sizer.dart'; // Add iconsax package for sexy icons

// class BillDetailScreen extends StatelessWidget {
//   const BillDetailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final BillModel bill = Get.arguments as BillModel;
//     final isOverdue = !bill.isPaid && DateTime.now().isAfter(bill.dueDate);

//     final theme = Theme.of(context);
//     return Scaffold(
//       // backgroundColor: theme.appBarTheme.backgroundColor,
//       appBar: CustomAppbar(title: "Bill Detail", isnotify: false, isback: true),
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: Padding(
//         padding: EdgeInsets.all(3.h),
//         child: Column(
//           children: [
//             _buildText(
//               bill.billId,
//               fontSize: 18.sp,
//               color: theme.appBarTheme.foregroundColor,
//             ),
//             SizedBox(height: 1.5.h),
//             _buildRow(
//               bill.billName,
//               bill.isPaid,
//               isStatus: true,
//               color1: theme.appBarTheme.foregroundColor,
//             ),

//             Divider(
//               color: theme.appBarTheme.foregroundColor!.withOpacity(0.4),
//               height: 2.h,
//             ),
//             _buildRow(
//               "Bill Amount",
//               "Issue Date",
//               fontSize1: 15.sp,
//               fontSize2: 15.sp,
//               color1: theme.appBarTheme.foregroundColor,
//               color2: theme.appBarTheme.foregroundColor,
//             ),
//             SizedBox(height: 1.h),
//             _buildRow(
//               bill.amount,
//               bill.issueDate,
//               fontSize1: 18.sp,
//               fontSize2: 18.sp,
//               isAmount: true,
//               isDate: true,
//               color1: theme.appBarTheme.foregroundColor,
//               color2: theme.appBarTheme.foregroundColor,
//             ),
//             SizedBox(height: 2.5.h),
//             _buildRow(
//               "Due Date",
//               "Expiration Date",
//               fontSize1: 15.sp,
//               fontSize2: 15.sp,
//               color1: theme.appBarTheme.foregroundColor,
//               color2: theme.appBarTheme.foregroundColor,
//             ),
//             SizedBox(height: 1.h),
//             _buildRow(
//               bill.dueDate,
//               bill.expiryDate,
//               fontSize1: 18.sp,
//               fontSize2: 18.sp,
//               isBothDate: true,
//               color1: theme.appBarTheme.foregroundColor,
//               color2: theme.appBarTheme.foregroundColor,
//             ),

//             SizedBox(height: 4.h),

//             bill.isPaid
//                 ? Column(
//                     children: [
//                       const Icon(
//                         Iconsax.tick_circle,
//                         color: Colors.green,
//                         size: 60,
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         "PAID",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   )
//                 : Center(
//                     child: FractionallyElevatedButton(
//                       onTap: () {
//                         Get.snackbar(
//                           "Payment",
//                           "Bill paid successfully!",
//                           backgroundColor: AppColors.success,
//                           colorText: Colors.white,
//                           snackPosition: SnackPosition.BOTTOM,
//                         );
//                       },
//                       backgroundColor: isOverdue
//                           ? AppColors.danger
//                           : AppColors.authButtonBakgroundColor,
//                       child: TitleText(
//                         title: isOverdue ? "PAY OVERDUE" : "PAY NOW",
//                         fontSize: 20,
//                         color: Colors.white,
//                         weight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildText(
//     String title, {
//     double? fontSize,
//     Color? color,
//     FontWeight? weight,
//     int maxLines = 2,
//   }) {
//     return TitleText(
//       title: title,
//       fontSize: fontSize ?? 16.sp,
//       color: color ?? Colors.black,
//       weight: weight ?? FontWeight.normal,
//       maxLines: maxLines,
//       overflow: TextOverflow.ellipsis,
//     );
//   }

//   Widget _buildIsPaid(bool isPaid) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 2.h),
//       decoration: BoxDecoration(
//         color: isPaid ? AppColors.primaryColor : AppColors.danger,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: _buildText(
//         isPaid ? "Paid" : "UnPaid",
//         color: AppColors.backgroundColor,
//         fontSize: 15.sp,
//         weight: FontWeight.w600,
//       ),
//     );
//   }

//   Widget _buildRow(
//     dynamic text1,
//     dynamic text2, {
//     bool isDate = false,
//     bool isAmount = false,
//     Color? color1 = Colors.black,
//     Color? color2 = Colors.black,
//     double? fontSize1 = 16,
//     double? fontSize2 = 16,
//     bool isStatus = false,
//     bool isBothDate = false,
//   }) {
//     if (isDate && isAmount) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildText(
//             formatAmountPKR(text1),
//             fontSize: fontSize1 ?? 18.sp,
//             color: color1,
//           ),
//           _buildText(
//             formatDate(text2),
//             fontSize: fontSize2 ?? 18.sp,
//             color: color2,
//           ),
//         ],
//       );
//     } else if (isDate) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildText(text1, fontSize: fontSize1 ?? 18.sp, color: color1),
//           _buildText(
//             formatDate(text2),
//             fontSize: fontSize2 ?? 18.sp,
//             color: color2,
//           ),
//         ],
//       );
//     } else if (isAmount) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildText(
//             formatAmountPKR(text1),
//             fontSize: fontSize1 ?? 18.sp,
//             color: color1,
//           ),
//           _buildText(text2, fontSize: fontSize2 ?? 18.sp, color: color2),
//         ],
//       );
//     } else if (isStatus) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildText(
//             text1,
//             fontSize: 22.sp,
//             weight: FontWeight.w600,
//             color: color1,
//           ),
//           _buildIsPaid(text2),
//         ],
//       );
//     } else if (isBothDate) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildText(
//             formatDate(text1),
//             fontSize: fontSize2 ?? 18.sp,
//             color: color1,
//           ),
//           _buildText(
//             formatDate(text2),
//             fontSize: fontSize2 ?? 18.sp,
//             color: color2,
//           ),
//         ],
//       );
//     } else {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildText(text1, fontSize: fontSize1 ?? 18.sp, color: color1),
//           _buildText(text2, fontSize: fontSize2 ?? 18.sp, color: color2),
//         ],
//       );
//     }
//   }
// }

import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/core/utils/global.dart';
import 'package:consumer_app/src/model/bill_model/bill_model.dart';
import 'package:consumer_app/src/view/components/common_components/custom_appbar.dart';
import 'package:consumer_app/src/view/components/common_components/fractionally_elevated_button.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class BillDetailScreen extends StatelessWidget {
  const BillDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BillModel bill = Get.arguments as BillModel;
    final isOverdue = !bill.isPaid && DateTime.now().isAfter(bill.dueDate);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(title: "Bill Detail", isnotify: false, isback: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(3.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildText(
              bill.billId,
              fontSize: 18.sp,
              color: theme.appBarTheme.foregroundColor,
            ),
            SizedBox(height: 1.5.h),

            _buildRow(
              bill.billName,
              bill.isPaid,
              isStatus: true,
              color1: theme.appBarTheme.foregroundColor,
              fontSize1: 18.sp,
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

            Center(
              child: bill.isPaid
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
                  : FractionallyElevatedButton(
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

  /// Reusable Text Builder
  Widget _buildText(
    dynamic title, {
    double? fontSize,
    Color? color,
    FontWeight? weight,
    int maxLines = 2,
  }) {
    return TitleText(
      title: title.toString(),
      fontSize: fontSize ?? 16.sp,
      color: color ?? Colors.black,
      weight: weight ?? FontWeight.normal,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Paid/Unpaid Badge
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
        fontSize: 13.sp,
        weight: FontWeight.w600,
      ),
    );
  }

  /// Row Builder
  Widget _buildRow(
    dynamic text1,
    dynamic text2, {
    bool isDate = false,
    bool isAmount = false,
    bool isStatus = false,
    bool isBothDate = false,
    Color? color1 = Colors.black,
    Color? color2 = Colors.black,
    double? fontSize1 = 16,
    double? fontSize2 = 16,
  }) {
    String leftText = text1.toString();
    String rightText = text2.toString();

    // Format text
    if (isAmount) leftText = formatAmountPKR(text1);
    if (isDate || isBothDate) rightText = formatDate(text2);
    if (isBothDate) leftText = formatDate(text1);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Expanded left side to avoid overflow
        Expanded(
          child: TitleText(
            title: leftText,
            fontSize: fontSize1 ?? 18.sp,
            color: color1,
            weight: isStatus ? FontWeight.w700 : FontWeight.w500,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 2.w),

        // Right side
        if (isStatus)
          _buildIsPaid(text2)
        else
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: TitleText(
                title: rightText,
                fontSize: fontSize2 ?? 18.sp,
                color: color2,
                weight: FontWeight.w500,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
      ],
    );
  }
}
