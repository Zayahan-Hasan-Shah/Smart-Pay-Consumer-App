import 'package:consumer_app/src/model/user_model/user_model.dart';
import 'package:consumer_app/src/view/components/common_components/custom_appbar.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.appBarTheme.backgroundColor,
      appBar: CustomAppbar(title: "Profile", isnotify: false),
      body: Padding(
        padding: EdgeInsetsGeometry.all(3.h),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildContainer(
                "USERNAME",
                "Zayahan",
                color: theme.appBarTheme.foregroundColor ?? Colors.black,
              ),
              SizedBox(height: 1.2.h),
              _buildContainer(
                "EMAIL",
                "zayahan@gmail.com",
                color: theme.appBarTheme.foregroundColor ?? Colors.black,
              ),
              SizedBox(height: 1.2.h),
              _buildContainer(
                "PHONE",
                "923327699138",
                color: theme.appBarTheme.foregroundColor ?? Colors.black,
              ),
              SizedBox(height: 1.2.h),
              _buildContainer(
                "CNIC",
                "923327699138",
                color: theme.appBarTheme.foregroundColor ?? Colors.black,
              ),
              SizedBox(height: 1.2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(
    String title, {
    double? fontSize,
    Color color = Colors.black,
    FontWeight? weight,
  }) {
    return TitleText(
      title: title,
      fontSize: fontSize ?? 16.sp,
      color: color,
      weight: weight ?? FontWeight.normal,
    );
  }

  Widget _buildContainer(
    String key,
    String value, {
    Color color = Colors.black,
  }) {
    return Container(
      padding: EdgeInsets.all(1.7.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blueGrey, width: 0.2.w),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            blurStyle: BlurStyle.outer,
            color: Colors.black12,
            spreadRadius: 1.5,
            offset: Offset(1,1),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildText(key, color: color),
          _buildText(value, color: color),
        ],
      ),
    );
  }
}
