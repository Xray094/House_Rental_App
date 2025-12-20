import 'package:get/get.dart';
import 'package:house_rental_app/Services/api_service.dart';
import 'package:house_rental_app/Services/booking_service.dart';
import 'package:house_rental_app/core/controllers/auth_controller.dart';
import 'package:house_rental_app/core/controllers/profile_controller.dart';
import 'package:house_rental_app/core/controllers/settings_controller.dart';
import 'package:house_rental_app/Services/auth_service.dart';
import 'package:house_rental_app/Services/apartment_repository.dart';
import 'package:house_rental_app/core/controllers/home_controller.dart';
import 'package:house_rental_app/Services/apartment_service.dart';
import 'package:house_rental_app/Services/logout_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    //Services
    Get.put(ApiService());
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(() => ApartmentService(), fenix: true);
    Get.lazyPut(() => LogoutService(), fenix: true);
    Get.lazyPut(() => BookingService());
    //Repositories
    Get.lazyPut(() => ApartmentRepository(), fenix: true);

    //Controllers
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
