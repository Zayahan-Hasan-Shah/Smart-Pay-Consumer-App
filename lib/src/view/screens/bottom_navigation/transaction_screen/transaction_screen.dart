import 'dart:io';
import 'package:consumer_app/src/controller/transaction_controller/transaction_controller.dart';
import 'package:consumer_app/src/model/transaction_model/transaction_model.dart';
import 'package:consumer_app/src/routes/route_names.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

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
    final controller = Get.put(TransactionController());
    controller.fetchTransactions();

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "💸 Transactions",
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 6,
        shadowColor: theme.shadowColor,
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: theme.appBarTheme.foregroundColor),
            onPressed: () {
              _downloadPDF(controller.transactions);
            },
          ),
        ],
      ),
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
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.transactions.length,
          itemBuilder: (context, index) {
            final txn = controller.transactions[index];
            return _transactionCard(txn);
          },
        );
      }),
    );
  }

  Widget _transactionCard(TransactionModel txn) {
    // Example logic kept for future styling decisions (currently unused)

    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteNames.transactionDetailScreen, arguments: txn);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount + Type Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _textBuild(
                  "Rs ${txn.amount}",
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
                    color: Colors.black.withOpacity(0.2),
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
