import 'dart:convert';
import 'dart:developer';

import 'package:consumer_app/src/core/constants/app_colors.dart';
import 'package:consumer_app/src/core/utils/device_helper.dart';
import 'package:consumer_app/src/model/auth_model/signup_model.dart';
import 'package:consumer_app/src/core/constants/api_url.dart';
import 'package:consumer_app/src/service/common_service/api_service.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupService {
  Uint8List encodeUtf16Le(String text) {
    var utf16LeBytes = <int>[];

    for (var codeUnit in text.codeUnits) {
      utf16LeBytes.add(codeUnit & 0xFF); // Low byte
      utf16LeBytes.add((codeUnit >> 8) & 0xFF); // High byte
    }

    return Uint8List.fromList(utf16LeBytes);
  }

  Future<SignupModel?> signup(
    String name,
    String email,
    String password,
    String phoneNumber,
    String cnic,
  ) async {
    try {
      String deviceId = await DeviceIdHelper.getDeviceId();
      log("Device ID: $deviceId");
      Uint8List encoded = encodeUtf16Le(password);
      var sendPassword = sha256.convert(encoded);
      var bodySent = {
        "name": name,
        "email": email,
        "password": sendPassword.toString(),
        "phoneNumber": phoneNumber,
        "cnicNumber": cnic,
        "deviceId": deviceId,
      };
      final response = await APIService.signup(
        api: ApiUrl.signupUrl,
        body: bodySent,
      );

      if (response != null) {
        final decoded = jsonDecode(response);
        final signupModel = SignupModel.fromJson(decoded);
        // Fallback success if API returns something truthy (mock)
        Get.snackbar(
          "Signup Successfull",
          "Congratulations",
          colorText: Colors.white,
          backgroundColor: AppColors.success,
          snackPosition: SnackPosition.BOTTOM,
        );
        return signupModel;
      }

      return null;
    } catch (e) {
      log('Signup failed : $e');
      Get.snackbar(
        "Signup Error",
        "Invalid details",
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }
}
