import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:consumer_app/src/core/constants/api_url.dart';
import 'package:consumer_app/src/routes/route_names.dart';
import 'package:consumer_app/src/service/common_service/api_service.dart';
import 'package:consumer_app/src/service/storage_service/storage_services.dart';
import 'package:consumer_app/src/service/token_service/token_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  Timer? _inactivityTimer;

  /// Duration after which user will be logged out automatically
  final Duration _timeoutDuration = const Duration(minutes: 2);

  void initialize() {
    _resetTimer();
    log("Session Manager initialized");
  }

  /// Call this whenever user interacts (tap, scroll, etc.)
  void userActivityDetected() {
    _resetTimer();
  }

  void _resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_timeoutDuration, _handleInactivityLogout);
  }

  Future<void> _handleInactivityLogout() async {
    log("User inactive for 2 minutes — logging out...");
    final StorageServices _service = StorageServices();
    var refreshToken = await _service.read("refresh_token");

    try {
      final Map<String, dynamic> bodySent = {
        "refreshToken": refreshToken
      };
      // Call logout API if needed
      await APIService.post(api: ApiUrl.logoutUrl, body: bodySent);

      // Clear all stored tokens
      await TokenManager().clearTokens();

      // Navigate to login screen
      Get.offAllNamed(RouteNames.loginScreen);
    } catch (e) {
      log("Error during inactivity logout: $e");
      Get.offAllNamed(RouteNames.loginScreen);
    }
  }

  void dispose() {
    _inactivityTimer?.cancel();
  }

  Future<void> logout({bool showMessage = true}) async {
  log("Manual logout initiated...");
  _inactivityTimer?.cancel();

  final StorageServices _service = StorageServices();
  var refreshToken = await _service.read("refresh_token");

  try {
    final Map<String, dynamic> bodySent = {
      "refreshToken": refreshToken,
    };

    // Call logout API if available
    await APIService.post(api: ApiUrl.logoutUrl, body: bodySent);

    // Clear tokens
    await TokenManager().clearTokens();

    // Navigate to login
    Get.offAllNamed(RouteNames.loginScreen);

    // Optional logout message
    if (showMessage) {
      Get.snackbar(
        "Logged Out",
        "You have been successfully logged out.",
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    log("Error during manual logout: $e");
    Get.offAllNamed(RouteNames.loginScreen);
    if (showMessage) {
      Get.snackbar(
        "Error",
        "Something went wrong during logout.",
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}


}
