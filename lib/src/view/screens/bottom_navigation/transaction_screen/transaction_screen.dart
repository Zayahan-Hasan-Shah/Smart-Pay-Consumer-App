import 'dart:io';
import 'package:consumer_app/src/controller/transaction_controller/transaction_controller.dart';
import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/model/transaction_model/transaction_model.dart';
import 'package:consumer_app/src/view/components/common_components/custom_appbar.dart';
import 'package:consumer_app/src/view/components/common_components/fractionally_elevated_button.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:consumer_app/src/view/components/transaction_components/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:sizer/sizer.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late final TransactionController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TransactionController());
    controller.fetchTransactions();
  }

  Future<void> _downloadPDF(List<TransactionModel> transactions) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              "Transaction Report",
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Table.fromTextArray(
            headers: [
              "ID",
              "Amount",
              "Date",
              "Time",
              "Type",
              "Sender",
              "Receiver",
            ],
            data: transactions.map((txn) {
              return [
                txn.transactionId,
                "Rs ${txn.amount}",
                "${txn.date.day}/${txn.date.month}/${txn.date.year}",
                txn.time,
                txn.type,
                txn.senderAccountName,
                txn.receiverAccountName,
              ];
            }).toList(),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/transactions.pdf");
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(title: "Transactions", isnotify: false),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.transactions.isEmpty) {
          return Center(
            child: Text(
              "No transactions found",
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
          );
        } else {
          final filtered = controller.filteredTransactions;

          return Column(
            children: [
              _buildTopSection(context),
              if (filtered.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      "No transactions match the selected filters",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.6),
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final txn = filtered[index];
                      return TransactionCard(txn: txn);
                    },
                  ),
                ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    // Keep these bounds consistent with controller defaults
    const double sliderMin = 0;
    const double sliderMax = 100000;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          color: AppColors.authButtonBakgroundColor.withAlpha(77),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📅 DATE RANGE SELECTOR
            GestureDetector(
              onTap: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: controller.selectedDateRange.value,
                );
                if (picked != null) {
                  controller.selectedDateRange.value = picked;
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 1.h),
                    Obx(() {
                      final range = controller.selectedDateRange.value;
                      final text = range == null
                          ? "Select Date Range"
                          : "${range.start.day}/${range.start.month}/${range.start.year} - ${range.end.day}/${range.end.month}/${range.end.year}";
                      return Text(
                        text,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black87,
                        ),
                      );
                    }),
                    const Spacer(),
                    // small clear date icon
                    Obx(() {
                      final has = controller.selectedDateRange.value != null;
                      return Visibility(
                        visible: has,
                        child: IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () =>
                              controller.selectedDateRange.value = null,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // 💰 AMOUNT RANGE SLIDER + Clear
            Obx(() {
              final values = controller.amountRange.value;
              // ensure values are within slider bounds (safety clamp)
              final start = values.start.clamp(sliderMin, sliderMax);
              final end = values.end.clamp(sliderMin, sliderMax);
              if (start != values.start || end != values.end) {
                controller.amountRange.value = RangeValues(start, end);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amount Range: Rs ${start.toInt()} - Rs ${end.toInt()}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RangeSlider(
                          values: controller.amountRange.value,
                          min: sliderMin,
                          max: sliderMax,
                          divisions: 100,
                          activeColor: AppColors.primaryColor,
                          inactiveColor: Colors.grey.shade300,
                          onChanged: (newRange) {
                            // keep values valid
                            final safeStart = newRange.start.clamp(
                              sliderMin,
                              sliderMax,
                            );
                            final safeEnd = newRange.end.clamp(
                              sliderMin,
                              sliderMax,
                            );
                            controller.amountRange.value = RangeValues(
                              safeStart,
                              safeEnd,
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 2.w),
                      // clear button for amount range
                      TextButton(
                        onPressed: controller.clearFilters,
                        child: Text("Clear Filters"),
                      ),
                    ],
                  ),
                ],
              );
            }),

            SizedBox(height: 2.h),

            // ⬇️ DOWNLOAD BUTTON
            FractionallyElevatedButton(
              onTap: () async {
                final toExport = controller.filteredTransactions;
                if (toExport.isEmpty) {
                  Get.snackbar(
                    "No data",
                    "No transactions to export for current filters.",
                    backgroundColor: AppColors.danger,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }
                await _downloadPDF(toExport);
                Get.snackbar(
                  "Success",
                  "Transactions downloaded successfully!",
                  backgroundColor: AppColors.success,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              widthFactor: 1,
              backgroundColor: AppColors.authButtonBakgroundColor,
              child: TitleText(
                title: "DOWNLOAD TRANSACTIONS",
                fontSize: 20,
                color: Colors.white,
                weight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
