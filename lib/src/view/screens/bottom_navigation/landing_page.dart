import 'package:consumer_app/src/controller/bottom_navigation_controller/bottom_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final controller = Get.put(BottomNavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.currentScreen),
      bottomNavigationBar: Obx(() {
        final theme = Theme.of(context);
        return BottomNavigationBar(
          backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
          selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
          currentIndex: controller.pageIndex.value,
          onTap: controller.setIndex,
          items: controller.tabs.map((tab) {
            return BottomNavigationBarItem(
              icon: Icon(tab.icon),
              label: tab.title,
            );
          }).toList(),
        );
      }),
    );
  }
}
