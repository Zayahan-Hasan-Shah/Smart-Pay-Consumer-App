import 'dart:developer';

import 'package:consumer_app/src/core/constants/app_assets.dart';
import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/core/constants/key.dart';
import 'package:consumer_app/src/routes/route_names.dart';
import 'package:consumer_app/src/service/storage_service/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  String? _appLogoPath; // Optional: Path to your app logo

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeInOut);

    // Start the animation
    _controller?.forward();

    _appLogoPath = AppAssets.logoImage;

    Future.delayed(const Duration(seconds: 3), () async {
      try {
        await StorageServices().write(tokenKey, apiKey);
        var key = await StorageServices().read(tokenKey);
        log("the key is $key");
        Get.offNamed(RouteNames.signupScreen);
      } catch (e) {
        log(e.toString());
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: AnimatedBuilder(
              animation: _animation!,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation?.value ?? 1,
                  child: Transform.scale(
                    scale: _animation?.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Customize these widgets based on your design
                  if (_appLogoPath != null) // Conditional for logo display
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Image.asset(
                        _appLogoPath!,
                        color: AppColors.primaryColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
