import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isback;
  final bool isnotify;
  final bool? istitleCenter;

  const CustomAppbar({
    super.key,
    required this.title,
    this.isback = false,
    required this.isnotify,
    this.istitleCenter = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
      title: TitleText(
        title: title,
        style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
          color: theme.appBarTheme.foregroundColor,
        ),
      ),
      leading: isback
          ? IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.chevron_left,
                color: theme.appBarTheme.foregroundColor,
              ),
            )
          : null,
      actions: [
        if (isnotify)
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_on_outlined,
              color: AppColors.appBarTitleTextColor,
              size: 30,
            ),
          ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.person,
            size: 30,
            color: theme.appBarTheme.foregroundColor,
          ),
        ),
      ],
    );
  }
}
