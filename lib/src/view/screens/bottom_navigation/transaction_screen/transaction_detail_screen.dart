import 'dart:io';
import 'package:consumer_app/src/core/utils/global.dart';
import 'package:consumer_app/src/model/transaction_model/transaction_model.dart';
import 'package:consumer_app/src/view/components/common_components/custom_appbar.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  Future<void> _downloadPDF(TransactionModel txn) async {
    final pdf = pw.Document();

    // Load fonts
    final fontRegular = pw.Font.ttf(
      await rootBundle.load("assets/fonts/SpaceGrotesk-Regular.ttf"),
    );
    final fontBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/SpaceGrotesk-Bold.ttf"),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Padding(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Transaction Detail",
                style: pw.TextStyle(font: fontBold, fontSize: 24),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "Transaction ID: ${txn.transactionId}",
                style: pw.TextStyle(font: fontRegular, fontSize: 16),
              ),
              pw.Text(
                "Amount: Rs ${txn.amount}",
                style: pw.TextStyle(font: fontRegular, fontSize: 16),
              ),
              pw.Text(
                "Date: ${txn.date.day}/${txn.date.month}/${txn.date.year}",
                style: pw.TextStyle(font: fontRegular, fontSize: 16),
              ),
              pw.Text(
                "Time: ${txn.time}",
                style: pw.TextStyle(font: fontRegular, fontSize: 16),
              ),
              pw.Text(
                "Type: ${txn.type}",
                style: pw.TextStyle(font: fontRegular, fontSize: 16),
              ),
              pw.Text(
                "Sender: ${txn.senderAccountName}",
                style: pw.TextStyle(font: fontRegular, fontSize: 16),
              ),
              pw.Text(
                "Receiver: ${txn.receiverAccountName}",
                style: pw.TextStyle(font: fontRegular, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );

    // Save PDF file
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/transaction_${txn.transactionId}.pdf");
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final txn = Get.arguments as TransactionModel;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppbar(title: txn.transactionId, isnotify: false, isback: true,),
      // appBar: AppBar(
      //   title: const Text("Transaction Detail"),
      //   backgroundColor: AppColors.primaryColor,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.download, color: Colors.white),
      //       onPressed: () => _downloadPDF(txn),
      //     ),
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                spacing: 1.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Info Tiles
                  // transaction id
                  _infoTile(
                    Icons.fingerprint_outlined,
                    "Transaction ID",
                    txn.transactionId,
                  ),
                  // transaction date and time
                  _infoTile(
                    Icons.calendar_today,
                    "Time & Date",
                    "${txn.time} - ${formatDate(txn.date)}",
                  ),
                  _infoTile(
                    Icons.payments_outlined,
                    "Amount",
                    formatAmountPKR(txn.amount).toString(),
                  ),
                  // chanel time
                  _infoTile(Icons.payment, "Chanel", txn.type),
                  _infoTile(Icons.person, "Sender", txn.senderAccountName),
                  _infoTile(
                    Icons.account_circle,
                    "Receiver",
                    txn.receiverAccountName,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.authButtonBakgroundColor, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _textBuild(
                  title,
                  color: AppColors.secondaryColor,
                  weight: FontWeight.w400,
                ),
                _textBuild(value, color: Colors.black, weight: FontWeight.w600),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TitleText _textBuild(String text, {Color? color, FontWeight? weight}) {
    return TitleText(
      title: text,
      fontSize: 16,
      color: color ?? Colors.black12,
      weight: weight ?? FontWeight.w500,
    );
  }
}
