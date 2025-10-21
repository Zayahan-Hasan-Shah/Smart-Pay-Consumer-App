import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/routes/route_names.dart';
import 'package:consumer_app/src/service/storage_service/storage_services.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final StorageServices _storageService = StorageServices();
    final theme = Theme.of(context);
    return Drawer(
      width: 70.w,
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: theme.appBarTheme.backgroundColor),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            children: [
              Row(
                children: [
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<String?>(
                        future: _storageService.read("user_name"),
                        builder: (context, snapshot) {
                          final name = snapshot.data ?? '';
                          return TitleText(
                            title: name,
                            fontSize: 20.sp,
                            color: theme.appBarTheme.foregroundColor,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 4.h),

              _drawerItem(
                LucideIcons.bellRing,
                color: theme.appBarTheme.foregroundColor!,
                "Reminders",

                () {
                  Get.back();
                  Get.toNamed(RouteNames.reminderScreen);
                },
              ),
              _drawerItem(
                LucideIcons.user,
                color: theme.appBarTheme.foregroundColor!,
                "Profile",
                () {
                  Get.back();
                  Get.toNamed("/profile");
                },
              ),
              const Divider(color: Colors.white30),
              _drawerItem(LucideIcons.logOut, "Logout", () {
                Get.back();
                Get.offAllNamed("/login");
              }, color: Colors.redAccent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        title,
        style: TextStyle(color: color, fontSize: 18.sp),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      hoverColor: Colors.white12,
      splashColor: Colors.white24,
    );
  }
}
