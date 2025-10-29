import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkManager extends GetxService {
  static NetworkManager get to => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _monitorConnection();
  }

  void _monitorConnection() async {
    // Initial check
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result as ConnectivityResult);

    // Listen for future changes
    _subscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // In most cases, there will be one result
      final current = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateConnectionStatus(current);
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    bool previous = isConnected.value;
    isConnected.value = result != ConnectivityResult.none;

    if (!isConnected.value && previous != isConnected.value) {
      _showNoInternetDialog();
    } else if (isConnected.value && previous != isConnected.value) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar(
        "Back Online",
        "Internet connection restored.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    final current = result.isNotEmpty ? result.first : ConnectivityResult.none;
    if (current == ConnectivityResult.none) {
      _showNoInternetDialog();
      return false;
    }
    return true;
  }

  void _showNoInternetDialog() {
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      barrierDismissible: false,
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("No Internet Connection"),
          content: const Text(
            "Please check your internet connection.\nYou cannot perform any actions until you are back online.",
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final connected = await checkConnection();
                  if (connected && (Get.isDialogOpen ?? false)) Get.back();
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
