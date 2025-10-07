import 'dart:developer';

import 'package:consumer_app/src/controller/bill_controller/bill_controller.dart';
import 'package:consumer_app/src/controller/consumer_number_controller/consumer_number_controller.dart';
import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/view/components/common_components/custom_appbar.dart';
import 'package:consumer_app/src/view/components/common_components/custom_dropdown.dart';
import 'package:consumer_app/src/view/components/common_components/custom_text_field.dart';
import 'package:consumer_app/src/view/components/common_components/fractionally_elevated_button.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final _formKey = GlobalKey<FormState>();
  final cNController = TextEditingController();
  final consumerController = Get.put(ConsumerNumberController());
  final controller = Get.put(BillController());
  String? selectedConsumerNumber;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(title: "Bills", isnotify: true),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _customField(),
              registerConsumerNumber(),
              _buildDropDown(),
            ],
          ),
        ),
      ),
    );
  }

  CustomTextField _customField() {
    return CustomTextField(
      controller: cNController,
      keyboardType: TextInputType.number,
      hintText: "Enter Consumer Number",
      isUnderLine: false,
      prefixIcon: Icon(Icons.qr_code_scanner_outlined),
    );
  }

  Widget registerConsumerNumber() {
    return Obx(
      () => Center(
        child: FractionallyElevatedButton(
          widthFactor: 1,
          backgroundColor: AppColors.authButtonBakgroundColor,
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              var result = await consumerController.consumerNumber(
                cNController.text.trim(),
              );
              log("RESULT : $result");
              if (result != null) {
                log("RESULT : $result");
                cNController.clear();
              }
            }
          },
          child: consumerController.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : TitleText(
                  title: "REGISTER",
                  color: AppColors.white,
                  fontSize: 20,
                  weight: FontWeight.w700,
                ),
        ),
      ),
    );
  }

  Widget _buildDropDown() {
    return CustomDropdown(
      items: [],
      hint: "Select Consumer Number",
      onChanged: (value) {
        setState(() {});
      },
    );
  }
}
