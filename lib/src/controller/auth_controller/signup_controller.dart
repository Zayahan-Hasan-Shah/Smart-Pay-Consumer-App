import 'dart:developer';

import 'package:consumer_app/src/model/auth_model/signup_model.dart';
import 'package:consumer_app/src/service/auth_service/signup_service.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
  }

  var isLoading = false.obs;
  var user = Rxn<SignupModel>();
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  Future<SignupModel?> signup(
    String name,
    String email,
    String password,
    String phoneNumber,
    String cnic,
  ) async {
    try {
      isLoading.value = true;
      final response = await SignupService().signup(
        name,
        email,
        password,
        phoneNumber,
        cnic
      );
      if (response != null) {
        user.value = response; // store in state
        return response;
      }
    } catch (e) {
      log("SignupController error: $e");
    } finally {
      isLoading.value = false;
    }
    return null;
  }
}
