import 'package:consumer_app/src/controller/auth_controller/login_controller.dart';
import 'package:consumer_app/src/model/bottom_tab_model/bottom_tab_model.dart';
import 'package:consumer_app/src/view/screens/bottom_navigation/bill_screen/bill_screen.dart';
import 'package:consumer_app/src/view/screens/bottom_navigation/dashboard_screen/dashboard_screen.dart';
import 'package:consumer_app/src/view/screens/bottom_navigation/profile_screen/profile_screen.dart';
import 'package:consumer_app/src/view/screens/bottom_navigation/setting_screen/setting_screen.dart';
import 'package:consumer_app/src/view/screens/bottom_navigation/transaction_screen/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  // Ensure controller is available even if not pre-registered
  final LoginController loginController = Get.put(LoginController());

  var pageIndex = 0.obs;
  var tabs = <BottomTab>[].obs;

  @override
  void onInit() {
    super.onInit();
    _configureTabs(); // 👈 initialize tabs here
  }

  void _configureTabs() {
    // For now, always show all tabs
    tabs.value = [
      BottomTab(
        title: "Dashboard",
        icon: Icons.dashboard,
        page: const DashboardScreen(),
      ),
      BottomTab(
        title: "Bills",
        icon: Icons.receipt_long,
        page: const BillScreen(),
      ),
      BottomTab(
        title: "Transactions",
        icon: Icons.swap_horiz,
        page: const TransactionScreen(),
      ),
      BottomTab(
        title: "Profile",
        icon: Icons.person,
        page: const ProfileScreen(),
      ),
      BottomTab(
        title: "Settings",
        icon: Icons.settings,
        page: const SettingScreen(),
      ),
    ];
  }

  void setIndex(int index) {
    if (index < tabs.length) {
      pageIndex.value = index;
    }
  }

  Widget get currentScreen => (pageIndex.value < tabs.length)
      ? tabs[pageIndex.value].page
      : const DashboardScreen();

  String get currentTitle => (pageIndex.value < tabs.length)
      ? tabs[pageIndex.value].title
      : "Dashboard";
}
