import 'package:get/get.dart';
import 'package:house_rental_app/Services/logout_service.dart';
import 'package:house_rental_app/Services/apartment_repository.dart';
import 'package:house_rental_app/core/controllers/auth_controller.dart';

class SettingsController extends GetxController {
  final isLoading = false.obs;
  final LogoutService _logoutService = Get.find<LogoutService>();
  final ApartmentRepository _repo = Get.find<ApartmentRepository>();

  Future<bool> logout() async {
    try {
      isLoading.value = true;
      final success = await _logoutService.logout();
      if (success) {
        // clear local persisted state
        _repo.clearCache();
        // delegate clearing user/token to AuthController
        final authC = Get.find<AuthController>();
        await authC.logout();
      }
      return success;
    } finally {
      isLoading.value = false;
    }
  }
}
