import 'package:consumer_app/src/core/constants/app_theme.dart';
import 'package:consumer_app/src/routes/app_routes.dart';
import 'package:consumer_app/src/routes/route_names.dart';
import 'package:consumer_app/src/view/screens/on_boarding/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'src/controller/theme_controller/theme_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return Sizer(
      builder: (context, orientation, deviceType) {
        return Obx(() {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            getPages: AppRoutes.routes,
            initialRoute: RouteNames.splashScreen,
            title: 'Consumer App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeController.theme,
            home: SplashScreen(),
          );
        });
      },
    );
  }
}
