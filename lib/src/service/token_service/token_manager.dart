import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:consumer_app/src/core/constants/api_url.dart';
import 'package:consumer_app/src/service/common_service/api_service.dart';
import 'package:consumer_app/src/service/storage_service/storage_services.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  final StorageServices _storage = StorageServices();
  Timer? _refreshTimer;

  Future<void> initialize() async {
    final expiresInStr = await _storage.read('expires_in');
    if (expiresInStr != null) {
      final expiresIn = int.tryParse(expiresInStr) ?? 0;
      if (expiresIn > 0) {
        _scheduleTokenRefresh(expiresIn);
      }
    }
  }

  Future<void> _scheduleTokenRefresh(int expiresIn) async {
    // Refresh 1 minute before expiry
    final refreshIn = (expiresIn - 60).clamp(0, expiresIn);
    _refreshTimer?.cancel();
    _refreshTimer = Timer(Duration(seconds: refreshIn), () async {
      await refreshToken();
    });
  }

  Future<void> refreshToken() async {
    try {
      final refreshToken = await _storage.read('refresh_token');
      if (refreshToken == null) {
        log("No refresh token found. Skipping refresh.");
        return;
      }

      log("🔄 Refreshing access token...");
      final response = await APIService.post(
        api: ApiUrl.refreshTokenUrl,
        body: {'refreshToken': refreshToken},
      );

      if (response != null) {
        final decoded = json.decode(response);
        final newAccessToken = decoded['accessToken'];
        final newRefreshToken = decoded['refreshToken'];
        final expiresIn = decoded['expiresIn'];

        await _storage.write('access_token', newAccessToken);
        await _storage.write('refresh_token', newRefreshToken);
        await _storage.write('expires_in', expiresIn.toString());

        log("Token refreshed successfully!");
        _scheduleTokenRefresh(expiresIn);
      } else {
        log("⚠️ Token refresh failed — server returned null");
      }
    } catch (e) {
      log("Token refresh error: $e");
      // If refresh fails, you might want to log out the user
    }
  }

  Future<void> clearTokens() async {
    _refreshTimer?.cancel();
    await _storage.delete('access_token');
    await _storage.delete('refresh_token');
    await _storage.delete('expires_in');
    log("Tokens cleared from local storage.");
  }
}