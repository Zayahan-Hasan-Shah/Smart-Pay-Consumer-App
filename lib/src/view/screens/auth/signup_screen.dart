import 'dart:developer';

import 'package:consumer_app/src/controller/auth_controller/signup_controller.dart';
import 'package:consumer_app/src/core/constants/app_assets.dart';
import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/core/utils/cnic_formatter.dart';
import 'package:consumer_app/src/core/utils/phone_number_formatter.dart';
import 'package:consumer_app/src/core/validation/app_validation.dart';
import 'package:consumer_app/src/routes/route_names.dart';
import 'package:consumer_app/src/view/components/common_components/app_size_component.dart';
import 'package:consumer_app/src/view/components/common_components/custom_text_field.dart';
import 'package:consumer_app/src/view/components/common_components/fractionally_elevated_button.dart';
import 'package:consumer_app/src/view/components/common_components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final cnicController = TextEditingController();

  final signupController = Get.put(SignupController());

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    cnicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Image.asset(
                                        AppAssets.logoImage,
                                        width:
                                            MediaQuery.of(context).size.height *
                                            0.3,
                                      ),
                                    ),
                                    headingText(
                                      "Join Smart Pay for seamless financial management.",
                                      fontSize: 20,
                                      isCenter: true,
                                    ),
                                    AppSize.vrtSpace(10),
                                    // user name
                                    headingText("User Name"),
                                    AppSize.vrtSpace(4),
                                    userTextField(),
                                    AppSize.vrtSpace(8),
                                    // email
                                    headingText("Email"),
                                    AppSize.vrtSpace(4),
                                    emailTextField(),
                                    AppSize.vrtSpace(8),
                                    // cnic
                                    headingText("CNIC"),
                                    AppSize.vrtSpace(4),
                                    cnicTextField(),
                                    AppSize.vrtSpace(8),
                                    // password
                                    headingText("Password"),
                                    AppSize.vrtSpace(4),
                                    Obx(() => passTextField()),
                                    AppSize.vrtSpace(8),
                                    // confirm password
                                    headingText("Confirm Password"),
                                    AppSize.vrtSpace(4),
                                    Obx(() => confPassTextField()),
                                    AppSize.vrtSpace(8),
                                    // phone number
                                    headingText("Phone Number"),
                                    AppSize.vrtSpace(4),
                                    phoneNoTextField(),
                                    AppSize.vrtSpace(8),

                                    AppSize.vrtSpace(10),
                                    signupButton(),
                                    _loginRouteBuild(),
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

  CustomTextField userTextField() {
    return CustomTextField(
      prefixIcon: Icon(Icons.person_outline_outlined),
      controller: userNameController,
      validator: validator,
      hintText: "Enter your username",
      hintColor: Colors.black,
      isUnderLine: false,
    );
  }

  CustomTextField emailTextField() {
    return CustomTextField(
      prefixIcon: Icon(Icons.mail_outline_outlined),
      controller: emailController,
      validator: validator,
      hintText: "Email",
      hintColor: Colors.black,
      isUnderLine: false,
    );
  }

  CustomTextField cnicTextField() {
    return CustomTextField(
      prefixIcon: Icon(Icons.qr_code_scanner_outlined),
      controller: cnicController,
      validator: validator,
      hintText: "CNIC",
      keyboardType: TextInputType.phone,
      hintColor: Colors.black,
      isUnderLine: false,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(13),
        CnicInputFormatter(),
      ],
    );
  }

  CustomTextField passTextField() {
    return CustomTextField(
      prefixIcon: Icon(Icons.lock_outline),
      controller: passwordController,
      validator: validator,
      hintText: "Password",
      hintColor: Colors.black,
      obsText: signupController.isPasswordHidden.value,
      isUnderLine: false,
      suffixIcon: IconButton(
        icon: Icon(
          signupController.isPasswordHidden.value
              ? Icons.visibility_off
              : Icons.visibility,
        ),
        onPressed: () {
          signupController.isPasswordHidden.toggle(); // 👈 toggle state
        },
      ),
    );
  }

  CustomTextField confPassTextField() {
    return CustomTextField(
      prefixIcon: Icon(Icons.lock_outline),
      controller: confirmPasswordController,
      hintColor: Colors.black,
      isUnderLine: false,
      validator: (value) =>
          confirmPasswordValidator(value, passwordController.text),
      hintText: "Confirm Password",
      obsText: signupController.isConfirmPasswordHidden.value, // 👈 reactive
      suffixIcon: IconButton(
        icon: Icon(
          signupController.isConfirmPasswordHidden.value
              ? Icons.visibility_off
              : Icons.visibility,
        ),
        onPressed: () {
          signupController.isConfirmPasswordHidden.toggle(); // 👈 toggle state
        },
      ),
    );
  }

  CustomTextField phoneNoTextField() {
    return CustomTextField(
      prefixIcon: Icon(Icons.phone_enabled_outlined),
      controller: phoneNumberController,
      validator: validator,
      hintText: "Phone Number",
      keyboardType: TextInputType.phone,
      hintColor: Colors.black,
      isUnderLine: false,
      inputFormatters: [PakistanPhoneFormatter()],
    );
  }

  Widget _loginRouteBuild() {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          Get.offAllNamed(RouteNames.loginScreen);
        },
        child: TitleText(
          title: 'Already have an account? Login',
          color: AppColors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget signupButton() {
    return Obx(
      () => Center(
        child: FractionallyElevatedButton(
          widthFactor: 1,
          backgroundColor: AppColors.authButtonBakgroundColor,
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              String cleanCnic = cnicController.text.replaceAll(
                RegExp(r'[^0-9]'),
                '',
              );
              final cleanPhone = phoneNumberController.text.replaceAll(
                RegExp(r'\D'),
                '',
              );
              var result = await signupController.signup(
                userNameController.text.trim(),
                emailController.text.trim(),
                passwordController.text.trim(),
                cleanPhone,
                cleanCnic,
              );
              log("RESULT BEFORE : ${result?.message}");
              if (result != null) {
                log("RESULT AFTER : ${result.message}");
                // String value = signupController;
                Get.offNamed(RouteNames.loginScreen);
              }
            }
          },
          child: signupController.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : TitleText(
                  title: "SIGNUP",
                  color: AppColors.white,
                  fontSize: 20,
                  weight: FontWeight.w700,
                ),
        ),
      ),
    );
  }
}
