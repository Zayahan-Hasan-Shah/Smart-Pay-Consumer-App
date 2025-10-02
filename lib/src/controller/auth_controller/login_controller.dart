import 'package:consumer_app/src/model/user_model/user_model.dart';
import 'package:consumer_app/src/service/auth_service/login_service.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isObsecure = true.obs;
  var isPasswordHidden = true.obs;

  // Store current user
  Rxn<UserModel> currentUser = Rxn<UserModel>();

  Future<UserModel?> login(String email, String password) async {
    try {
      isLoading.value = true;
      UserModel? response = await LoginService().login(email, password);
      if (response != null) {
        currentUser.value = response;
        isLoading.value = false;
        return response;
      }
      isLoading.value = false;
      return null;
    } catch (e) {
      isLoading.value = false;
      return null;
    }
  }
}
