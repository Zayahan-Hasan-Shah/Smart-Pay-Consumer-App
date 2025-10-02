import 'package:consumer_app/src/controller/theme_controller/theme_controller.dart';
import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    "https://i.ibb.co/5M0QZVB/avatar.png",
                  ), // placeholder
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hey, Zayahan 👋",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const Text(
                      "Manage your preferences",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

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
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(
                      "Dark Mode",
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      themeController.isDarkMode.value
                          ? "Turn off to use light theme"
                          : "Turn on to go dark & sexy 🌙",
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
          backgroundColor: Theme.of(
            Get.context!,
          ).colorScheme.primary.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(Get.context!).colorScheme.primary),
        ),
        title: Text(
          title,
          style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
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
