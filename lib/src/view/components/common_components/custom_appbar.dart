import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isback;

  const CustomAppbar({super.key, required this.title, this.isback = false});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: AppColors.white),
      backgroundColor: AppColors.primaryColor,
      elevation: 1,
      title: TitleText(title: title, fontSize: 18.sp, color: AppColors.white),
      leading: isback
          ? IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.chevron_left, color: AppColors.white),
            )
          : null,
    );
  }
}
