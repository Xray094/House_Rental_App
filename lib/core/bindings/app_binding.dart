import 'package:get/get.dart';
import 'package:house_rental_app/Services/api_service.dart';
import 'package:house_rental_app/Services/booking_service.dart';
import 'package:house_rental_app/core/controllers/apartment_booking_controller.dart';
import 'package:house_rental_app/core/controllers/auth_controller.dart';
import 'package:house_rental_app/core/controllers/landlord_aparments_controller.dart';
import 'package:house_rental_app/core/controllers/settings_controller.dart';
import 'package:house_rental_app/Services/auth_service.dart';
import 'package:house_rental_app/core/controllers/home_controller.dart';
import 'package:house_rental_app/Services/apartment_service.dart';
import 'package:house_rental_app/Services/logout_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService());
    Get.put(ApartmentService());
    Get.lazyPut(() => BookingService(), fenix: true);
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(() => LogoutService(), fenix: true);

    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => LandlordApartmentsController(), fenix: true);
    Get.lazyPut(() => ApartmentBookingController(), fenix: true);
  }
}
