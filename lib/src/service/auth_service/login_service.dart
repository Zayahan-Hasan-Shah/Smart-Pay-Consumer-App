import 'dart:convert';
import 'dart:developer';

import 'package:consumer_app/src/core/constants/api_url.dart';
import 'package:consumer_app/src/core/utils/device_helper.dart';
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
      String deviceId = await DeviceIdHelper.getDeviceId();
      log("Device ID: $deviceId");
      Uint8List encoded = encodeUtf16Le(password);
      log("UTL16 ENCODED PASSWORD IS : $encoded");
      var sendPassword = sha256.convert(encoded);
      var bodySent = {
        "email": email,
        "password": sendPassword.toString(),
        "deviceId": deviceId,
      };
      log("Request body : $bodySent");
      var response = await APIService.login(
        api: ApiUrl.loginUrl,
        body: bodySent,
      );

      if (response != null) {
        Get.snackbar(
          "Login Successfully",
          "Welcome",
          colorText: Colors.white,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
        );
        final parsedList = userModelFromJson(response);
        return parsedList;
      }
      Get.snackbar(
        "Login Error",
        "Invalid Credentials",
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      log("LOGIN SERVICE ERROR : $e");
      return null;
    }
  }
}
