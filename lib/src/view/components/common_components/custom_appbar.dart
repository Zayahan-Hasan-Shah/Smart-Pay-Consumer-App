import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/routes/route_names.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:lucide_icons/lucide_icons.dart'; // for clean modern icons

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isback;
  final bool isnotify;
  final bool? istitleCenter;
  final bool hasDrawer;

  const CustomAppbar({
    super.key,
    required this.title,
    this.isback = false,
    required this.isnotify,
    this.istitleCenter = true,
    this.hasDrawer = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      shape: Border(
        bottom: BorderSide(color: AppColors.appBarBottomBorderColor, width: 1),
      ),
      centerTitle: istitleCenter ?? false,
      iconTheme: const IconThemeData(color: AppColors.white),
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 1,
      leading: Builder(
        builder: (context) {
          if (hasDrawer) {
            // ✅ If drawer is enabled, show hamburger
            return IconButton(
              icon: Icon(
                LucideIcons.menu,
                color: theme.appBarTheme.foregroundColor,
              ),
              onPressed: () => _openDrawer(context),
            );
          } else if (isback) {
            // ✅ Else show back button
            return IconButton(
              icon: Icon(
                LucideIcons.chevronLeft,
                color: theme.appBarTheme.foregroundColor,
              ),
              onPressed: () => Get.back(),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      title: TitleText(
        title: title,
        style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
          color: theme.appBarTheme.foregroundColor,
        ),
      ),
      actions: [
        if (isnotify)
          IconButton(
            onPressed: () {
              Get.toNamed(RouteNames.reminderScreen);
            },
            icon: Icon(
              LucideIcons.bell,
              color: theme.appBarTheme.foregroundColor,
              size: 26,
            ),
          ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            LucideIcons.user,
            size: 26,
            color: theme.appBarTheme.foregroundColor,
          ),
        ),
      ],
    );
  }
}
