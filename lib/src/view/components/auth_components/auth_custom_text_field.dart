import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AuthCustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obsText;
  final VoidCallback? toggle;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool isUnderLine;
  final Color? hintColor;
  final double? fontSize;

  const AuthCustomTextField({
    Key? key,
    required this.controller,
    this.obsText = false,
    this.toggle,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.hintText,
    this.isUnderLine = true,
    this.hintColor,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: AppColors.black, fontSize: fontSize),
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obsText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor, fontSize: fontSize),
        focusedBorder: isUnderLine
            ? const UnderlineInputBorder()
            : OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white),
                borderRadius: BorderRadius.circular(8),
              ),
        enabledBorder: isUnderLine
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              )
            : OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
        suffixIcon: suffixIcon ??
            (toggle != null
                ? IconButton(
                    icon: Icon(
                      obsText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: toggle,
                  )
                : null),
      ),
    );
  }
}