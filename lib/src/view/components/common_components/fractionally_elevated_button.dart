import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FractionallyElevatedButton extends StatelessWidget {
  const FractionallyElevatedButton({
    super.key,
    required this.onTap,
    this.widthFactor,
    this.child,
    this.backgroundColor,
  });

  final Widget? child;
  final double? widthFactor;
  final VoidCallback onTap;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor ?? 0.7,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryColor,
          elevation: 0,
          side: const BorderSide(color: AppColors.black,),
          visualDensity: const VisualDensity(vertical: 2, horizontal: 2),
        ),
        onPressed: onTap,
        child: child,
      ),
    );
  }
}
