import 'package:consumer_app/src/controller/bill_controller/bill_controller.dart';
import 'package:consumer_app/src/controller/consumer_number_controller/consumer_number_controller.dart';
import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/model/bill_model/bill_model.dart';
import 'package:consumer_app/src/routes/route_names.dart';
import 'package:consumer_app/src/service/storage_service/storage_services.dart';
import 'package:consumer_app/src/view/components/common_components/custom_appbar.dart';
import 'package:consumer_app/src/view/components/common_components/custom_dropdown.dart';
import 'package:consumer_app/src/view/components/common_components/custom_text_field.dart';
import 'package:consumer_app/src/view/components/common_components/fractionally_elevated_button.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:consumer_app/src/view/components/bill_components/bill_list_component.dart';
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
  final billController = Get.put(BillController());
  String? selectedConsumerNumber;

  @override
  void initState() {
    super.initState();
    _loadConsumerNumbers();
  }

  Future<void> _loadConsumerNumbers() async {
    final userId = await StorageServices().read("user_id");
    await consumerController.getConsumerNumbrOfUser(userId.toString());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(title: "Bills", isnotify: true),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Obx(() {
          if (consumerController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (consumerController.consumerNumbers.isEmpty) {
            // User has no consumer numbers yet → show only register form
            return _registerForm();
          }

          // User has some numbers → show dropdown + register form + bill list
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(
                title: "Select Consumer Number",
                fontSize: 14.sp,
                weight: FontWeight.w600,
              ),
              SizedBox(height: 1.h),
              _buildDropDown(),
              SizedBox(height: 2.h),
              Expanded(child: _buildBillsList()),
              const Divider(thickness: 1.2),
              SizedBox(height: 2.h),
              TitleText(
                title: "Register Another Consumer Number",
                fontSize: 14.sp,
                weight: FontWeight.w600,
              ),
              SizedBox(height: 1.h),
              _registerForm(showDivider: false),
            ],
          );
        }),
      ),
    );
  }

  /// Registration form — reusable (for initial or additional registration)
  Widget _registerForm({bool showDivider = true}) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: cNController,
            keyboardType: TextInputType.number,
            hintText: "Enter Consumer Number",
            isUnderLine: false,
            prefixIcon: const Icon(Icons.qr_code_scanner_outlined),
          ),
          SizedBox(height: 2.h),
          Obx(
            () => FractionallyElevatedButton(
              widthFactor: 1,
              backgroundColor: AppColors.authButtonBakgroundColor,
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  await consumerController.consumerNumber(
                    cNController.text.trim(),
                  );
                  cNController.clear();
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
          if (showDivider) ...[
            SizedBox(height: 2.h),
            const Divider(thickness: 1),
          ],
        ],
      ),
    );
  }

  /// Dropdown of all existing consumer numbers
  Widget _buildDropDown() {
    final items = consumerController.consumerNumbers;

    return CustomDropdown(
      items: items.map((e) => e.number).toList(),
      hint: "Select Consumer Number",
      onChanged: (selectedNumber) async {
        final selected = items.firstWhere((e) => e.number == selectedNumber);
        billController.currentConsumerNumberId =
            selected.consumerNumberId; // ✅ Save ID globally
        await billController.fetchBillsByConsumerId(selected.consumerNumberId);
      },
    );
  }

  /// Bills section
  Widget _buildBillsList() {
    return Obx(() {
      if (billController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (billController.bills.isEmpty) {
        return const Center(child: Text("No bills found"));
      }

      final displayedBills = billController.filteredBills.isNotEmpty
          ? billController.filteredBills
          : billController.bills;

      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              billController.hasNext &&
              !billController.isLoadingMore.value) {
            billController.loadMoreBills();
          }
          return false;
        },
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(
                  Icons.filter_alt,
                  color: AppColors.primaryColor,
                ),
                onPressed: () => _showFilterSheet(),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  if (billController.currentConsumerNumberId != null) {
                    await billController.fetchBillsByConsumerId(
                      billController.currentConsumerNumberId!,
                      refresh: true,
                    );
                  }
                },
                child: ListView.builder(
                  itemCount: displayedBills.length,
                  itemBuilder: (context, index) {
                    final BillModel bill = displayedBills[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.5.h),
                      child: GestureDetector(
                        onTap: () => Get.toNamed(
                          RouteNames.billDetailScreen,
                          arguments: bill,
                        ),
                        child: BillListComponent(bill: bill),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showFilterSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(3.h),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleText(
              title: "Filter Bills",
              fontSize: 20,
              weight: FontWeight.bold,
            ),
            SizedBox(height: 2.h),
            _buildFilterOption("Due Date", BillFilterType.dueDate),
            // _buildFilterOption("Issue Date", BillFilterType.issueDate),
            _buildFilterOption("Paid Bills", BillFilterType.paid),
            _buildFilterOption("Unpaid Bills", BillFilterType.unpaid),
            _buildFilterOption("Reminder Bills", BillFilterType.reminder),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    billController.clearFilters();
                    Get.back();
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text("Clear"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.check),
                  label: const Text("Apply"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.authButtonBakgroundColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, BillFilterType type) {
    return Obx(() {
      final isSelected = billController.selectedFilters.contains(type);
      return CheckboxListTile(
        value: isSelected,
        title: Text(title),
        activeColor: AppColors.authButtonBakgroundColor,
        onChanged: (val) => billController.toggleFilter(type),
      );
    });
  }
}
