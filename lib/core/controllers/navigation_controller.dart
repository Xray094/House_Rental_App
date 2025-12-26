import 'package:get/get.dart';
import 'package:house_rental_app/Models/user_model.dart';
import 'package:house_rental_app/core/controllers/auth_controller.dart';
import 'package:house_rental_app/core/controllers/booking_controller.dart';
import 'package:house_rental_app/core/controllers/favorites_controller.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  final Rxn<UserModel> user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<UserModel>()) {
      user.value = Get.find<AuthController>().user.value;
    }
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
    if (isTenant && index == 1) {
      try {
        if (Get.isRegistered<BookingController>()) {
          Get.find<BookingController>().fetchMyBookings();
        } else {
          Get.put(BookingController()).fetchMyBookings();
        }
      } catch (_) {}
    }
    if (isTenant && index == 2) {
      try {
        if (Get.isRegistered<FavoritesController>()) {
          Get.find<FavoritesController>().loadFavorites();
        } else {
          Get.put(FavoritesController()).loadFavorites();
        }
      } catch (_) {}
    }
  }

  bool get isTenant => user.value?.attributes.role == 'tenant';
}
