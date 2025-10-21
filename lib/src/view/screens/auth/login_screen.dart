import 'dart:developer';

import 'package:consumer_app/src/controller/auth_controller/login_controller.dart';
import 'package:consumer_app/src/core/constants/app_assets.dart';
import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/core/validation/app_validation.dart';
import 'package:consumer_app/src/routes/route_names.dart';
import 'package:consumer_app/src/service/storage_service/storage_services.dart';
import 'package:consumer_app/src/view/components/common_components/app_size_component.dart';
import 'package:consumer_app/src/view/components/common_components/custom_text_field.dart';
import 'package:consumer_app/src/view/components/common_components/fractionally_elevated_button.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final loginController = Get.put(LoginController());
  final StorageServices storage = Get.put(StorageServices());

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppAssets.coolBackgroundImage,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(7),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Image.asset(
                                  AppAssets.logoImage,
                                  width:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                              ),
                              headingText(
                                "Welcome",
                                fontSize: 30,
                                isCenter: true,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppSize.vrtSpace(10),

                                    // email
                                    headingText("Email"),
                                    AppSize.vrtSpace(4),
                                    emailTextField(),
                                    AppSize.vrtSpace(10),
                                    // password
                                    headingText("Password"),
                                    AppSize.vrtSpace(4),
                                    Obx(() => passTextField()),
                                    AppSize.vrtSpace(10),
                                    loginButton(),
                                    _signupRouteBuild(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headingText(
    String text, {
    bool isCenter = false,
    double? fontSize = 18,
  }) {
    return TitleText(
      title: text,
      fontSize: fontSize ?? 18,
      color: Colors.black,
      alignText: isCenter ? TextAlign.center : null,
    );
  }

  CustomTextField emailTextField() {
    return CustomTextField(
      isUnderLine: false,
      prefixIcon: Icon(Icons.mail_outline_outlined),
      controller: emailController,
      validator: validator,
      hintText: "Email",
      hintColor: Colors.black,
    );
  }

  CustomTextField passTextField() {
    return CustomTextField(
      controller: passwordController,
      prefixIcon: Icon(Icons.lock_outline),
      isUnderLine: false,
      validator: validator,
      hintText: "Password",
      hintColor: Colors.black,
      obsText: loginController.isPasswordHidden.value,
      suffixIcon: IconButton(
        icon: Icon(
          loginController.isPasswordHidden.value
              ? Icons.visibility_off
              : Icons.visibility,
        ),
        onPressed: () {
          loginController.isPasswordHidden.toggle(); // 👈 toggle state
        },
      ),
    );
  }

  Widget _signupRouteBuild() {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          Get.offAllNamed(RouteNames.signupScreen);
        },
        child: TitleText(
          title: 'Don\'t have an account? Signup',
          color: AppColors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget loginButton() {
    return Obx(
      () => Center(
        child: FractionallyElevatedButton(
          widthFactor: 1,
          backgroundColor: AppColors.authButtonBakgroundColor,
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              var result = await loginController.login(
                emailController.text.trim(),
                passwordController.text.trim(),
              );
              log("RESULT  BEFORE IF: $result");
              if (result != null) {
                log("RESULT AFTER IF : $result");
                StorageServices().write("user_id", result.userId.toString());
                StorageServices().write("user_name", result.name);
                Get.offNamed(RouteNames.landingPageScreen);
              }
            }
          },
          child: loginController.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : TitleText(
                  title: "LOGIN",
                  color: AppColors.white,
                  fontSize: 20,
                  weight: FontWeight.w700,
                ),
        ),
      ),
    );
  }
}
