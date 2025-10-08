import 'package:consumer_app/src/controller/theme_controller/theme_controller.dart';
import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/routes/route_names.dart';
import 'package:consumer_app/src/view/components/common_components/custom_appbar.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppbar(title: "Settings", isnotify: false),
      body: Column(
        children: [
          // Settings List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _settingTile(
                  icon: Icons.person,
                  title: "Account",
                  subtitle: "Update your profile info",
                  onTap: () {},
                ),
                _settingTile(
                  icon: Icons.lock,
                  title: "Privacy",
                  subtitle: "Password, fingerprint, FaceID",
                  onTap: () {},
                ),
                _settingTile(
                  icon: Icons.notifications,
                  title: "Notifications",
                  subtitle: "Control push & email alerts",
                  onTap: () {},
                ),

                // 🔥 Dark Mode Switch
                Obx(
                  () => SwitchListTile(
                    value: themeController.isDarkMode.value,
                    onChanged: (value) => themeController.toggleTheme(),
                    secondary: Icon(
                      Icons.dark_mode,
                      color: const Color.fromARGB(255, 19, 37, 53), // theme.colorScheme.primary,
                    ),
                    title: TitleText(
                      title: "Dark Mode",
                      fontSize: 17.sp,
                      weight: FontWeight.w600,
                    ),
                    // title: Text(
                    //   "Dark Mode",
                    //   style: theme.textTheme.titleMedium,
                    // ),
                    subtitle: Text(
                      themeController.isDarkMode.value
                          ? "Turn off to use light theme"
                          : "Turn on to use dark theme",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),

                const Divider(),

                _settingTile(
                  icon: Icons.info,
                  title: "About App",
                  subtitle: "Version 1.0.0",
                  onTap: () {},
                ),
                _settingTile(
                  icon: Icons.logout,
                  title: "Logout",
                  subtitle: "Exit your account",
                  onTap: () {
                    Get.snackbar(
                      "Logout",
                      "You have been logged out!",
                      backgroundColor: AppColors.danger,
                      colorText: AppColors.white,
                    );
                    Get.offAllNamed(RouteNames.loginScreen);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.authButtonBakgroundColor.withOpacity(0.1),
          // backgroundColor: Theme.of(
          //   Get.context!,
          // ).colorScheme.primary.withOpacity(0.1),
          child: Icon(
            icon,
            color: AppColors.authButtonBakgroundColor,
          ), // Theme.of(Get.context!).colorScheme.primary),
        ),
        title: TitleText(
          title: title,
          fontSize: 17.sp,
          weight: FontWeight.w600,
                  // style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
          //   fontWeight: FontWeight.bold,
          //   fontSize: 16,
          
      
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(Get.context!).textTheme.bodyMedium,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
