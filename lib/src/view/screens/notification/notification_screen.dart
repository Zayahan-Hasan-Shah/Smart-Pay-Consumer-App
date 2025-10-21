import 'package:consumer_app/src/view/components/common_components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "Notifications",
        isnotify: false,
        isback: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Obx(() {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Text('data');
            },
          );
        }),
      ),
    );
  }
}
