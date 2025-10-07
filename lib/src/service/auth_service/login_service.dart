import 'dart:convert';
import 'dart:developer';

import 'package:consumer_app/src/model/user_model/user_model.dart';
import 'package:consumer_app/src/service/common_service/api_service.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

class LoginService {
  Uint8List encodeUtf16Le(String text) {
    var utf16LeBytes = <int>[];

    for (var codeUnit in text.codeUnits) {
      utf16LeBytes.add(codeUnit & 0xFF); // Low byte
      utf16LeBytes.add((codeUnit >> 8) & 0xFF); // High byte
    }

    return Uint8List.fromList(utf16LeBytes);
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      Uint8List encoded = encodeUtf16Le(password);
      var sendPassword = sha256.convert(encoded);
      var bodySent = {"LoginId": email, "Password": sendPassword.toString()};

      if (email == 'zayahan@gmail.com' && password == '123qwe') {
        Get.snackbar(
          "Login Successfully",
          "Welcome",
          colorText: Colors.white,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
        );
        return UserModel(
          id: 1,
          name: "Zayahan",
          email: "zayahan@gmail.com",
          phoneNumber: "923327699137",
        );
      } else {
        Get.snackbar(
          "Login Error",
          "Invalid Credentials",
          colorText: Colors.white,
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
        ); // explicitly return null
        return null;
      }
      // var response = await APIService.login(api: '', body: bodySent);

      // if (response != null) {
      //   Get.snackbar(
      //     "Login Successfully",
      //     "Welcome",
      //     colorText: Colors.white,
      //     backgroundColor: Colors.green,
      //     snackPosition: SnackPosition.BOTTOM,
      //   );
      //   final parsedList = userModelFromJson(response);
      //   return parsedList;
      // }
      // Get.snackbar(
      //   "Login Error",
      //   "Invalid Credentials",
      //   colorText: Colors.white,
      //   backgroundColor: Colors.redAccent,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    } catch (e) {
      log("LOGIN SERVICE ERROR : $e");
      return null;
    }
  }
}
