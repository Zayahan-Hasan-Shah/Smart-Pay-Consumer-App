import 'dart:developer';

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
      Uint8List encoded = encodeUtf16Le(password);
      var sendPassword = sha256.convert(encoded);
      var bodySent = {
        "name": name,
        "email": email,
        "password": sendPassword.toString(),
        "phoneNumber": phoneNumber,
        "cnic": cnic,
      };
      // TODO: Replace with actual API usage/handling
      final response = await APIService.post(api: ApiUrl.signup, body: bodySent);
      if (name == "zayahan" &&
          email == "zayahan@gmail.com" &&
          password == "123qwe" &&
          phoneNumber == "923327699137" &&
          cnic == "4250180883267") {
        Get.snackbar(
          "Signup Successfully",
          "Welcome",
          colorText: Colors.white,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
        );
        return SignupModel(
          name: name,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          cnic: cnic,
        );
      }
      if (response != null) {
        // Fallback success if API returns something truthy (mock)
        return SignupModel(
          name: name,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          cnic: cnic,
        );
      }
      Get.snackbar(
        "Signup Error",
        "Invalid details",
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } catch (e) {
      log('Signup failed : $e');
      return null;
    }
  }
}
