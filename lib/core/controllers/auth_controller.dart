import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Services/auth_service.dart';
import 'package:house_rental_app/Models/login_model.dart';
import 'package:house_rental_app/Models/user_model.dart';
import 'package:house_rental_app/core/controllers/theme_controller.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final AuthService _authService = Get.find<AuthService>();

  final Rxn<UserModel> user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> login(String mobile, String password) async {
    try {
      isLoading.value = true;
      final result = await _authService.login(
        LoginModule(mobile: mobile, password: password),
      );
      if (result != null) {
        user.value = result;
        Get.put<UserModel>(result, permanent: true);
        final box = Get.find<GetStorage>();
        box.write('token', result.token);
        return true;
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final box = Get.find<GetStorage>();
    await box.remove('token');
    user.value = null;

    final themeController = Get.find<ThemeController>();
    themeController.setThemeMode(false);
  }

  Future<bool> validateCurrentToken() async {
    try {
      final box = Get.find<GetStorage>();
      final token = box.read('token');

      if (token == null) {
        return false;
      }

      final result = await _authService.validateToken();
      if (result != null) {
        user.value = result;
        Get.put<UserModel>(result, permanent: true);
        return true;
      }
      return false;
    } catch (e) {
      print('Token validation error: $e');
      return false;
    }
  }

  bool get isTenant => user.value?.attributes.role == 'tenant';
}
