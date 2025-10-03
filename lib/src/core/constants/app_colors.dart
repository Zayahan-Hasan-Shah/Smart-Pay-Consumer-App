import 'package:flutter/material.dart';

class AppColors {
  // Base Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;

  // Brand Colors
  static const Color primaryColor = Color(0xff448f44); 
  static const Color secondaryColor = Color(0xff2575fc); 
  static const Color backgroundColor = Color(0xfff7f7f7);

  // Status Colors
  static const Color success = Color(0xff16a34a);
  static const Color danger = Color(0xffdc2626);
  static const Color warning = Color(0xfff59e0b);
  static const Color info = Color(0xff0284c7);

  // Neutral Palette
  static const Color lightGrey = Color(0xffe5e7eb);
  static const Color darkGrey = Color(0xff374151);
  static const Color borderColor = Color(0xffd1d5db);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xff448f44), Color(0xff27632a)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xff2575fc), Color(0xff6a11cb)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xff4ade80), Color(0xff16a34a)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xfff87171), Color(0xffb91c1c)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xfffbbf24), Color(0xffd97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neutralGradient = LinearGradient(
    colors: [Color(0xffe5e7eb), Color(0xff9ca3af)]  ,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );


  //=====================================================================================

  static const authButtonBakgroundColor = Color(0xFF3A93E6);

}
