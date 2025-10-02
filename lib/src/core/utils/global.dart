import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';

String formatNumber(int number) {
  List<String> suffixes = ['', 'K', 'M', 'B', 'T'];
  int suffixIndex = 0;
  double formattedNumber = number.toDouble();

  while (formattedNumber >= 1000 && suffixIndex < suffixes.length - 1) {
    formattedNumber /= 1000;
    suffixIndex++;
  }

  String formattedString = formattedNumber.toStringAsFixed(1);
  if (formattedString.endsWith('.0')) {
    formattedString = formattedString.substring(0, formattedString.length - 2);
  }

  return '$formattedString${suffixes[suffixIndex]}';
}


BoxDecoration get customMainCardDecoration {
  return BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.grey.withAlpha(13),
        spreadRadius: 1,
        blurRadius: 10,
        offset: const Offset(0, 10),
      ),
    ],
    color: AppColors.white,
  );
}