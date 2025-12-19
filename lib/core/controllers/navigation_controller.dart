import 'package:get/get.dart';
import 'package:house_rental_app/Models/user_model.dart';
import 'package:house_rental_app/core/controllers/auth_controller.dart';
import 'package:house_rental_app/core/controllers/booking_controller.dart';

class NavigationController extends GetxController {
  // Reactive index for the bottom bar
  var selectedIndex = 0.obs;

  // Reactive User model
  final Rxn<UserModel> user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    // Logic to find the user data that was stored during login/splash
    if (Get.isRegistered<UserModel>()) {
      user.value = Get.find<AuthController>().user.value;
    }
  }

  void changeIndex(int index) {
    selectedIndex.value = index;

    // If tenant navigated to the Bookings tab (index 1), refresh bookings list
    if (isTenant && index == 1) {
      try {
        if (Get.isRegistered<BookingController>()) {
          Get.find<BookingController>().fetchMyBookings();
        } else {
          // Instantiate and fetch
          Get.put(BookingController()).fetchMyBookings();
        }
      } catch (_) {
        // ignore errors; booking page will fetch on init if necessary
      }
    }
  }

  // Helper getter to check role safely
  bool get isTenant => user.value?.attributes.role == 'tenant';
}
