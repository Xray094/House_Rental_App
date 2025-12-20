import 'package:get/get.dart';
import 'package:house_rental_app/Views/Login&Register/second_register_page.dart';
import 'package:house_rental_app/Views/create_apartment.dart';
import 'package:house_rental_app/Views/splash_page.dart';
import 'package:house_rental_app/Views/Login&Register/login_page.dart';
import 'package:house_rental_app/Views/Login&Register/first_register_page.dart';
import 'package:house_rental_app/Views/main_navigation_page.dart';
import 'package:house_rental_app/Views/profile_page.dart';
import 'package:house_rental_app/Views/apartment_detail_page.dart';
import 'package:house_rental_app/core/controllers/apartment_controller.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.splash, page: () => const SplashPage()),
    GetPage(name: Routes.login, page: () => LoginPage()),
    GetPage(name: Routes.register, page: () => FirstRegisterPage()),
    GetPage(name: Routes.main, page: () => MainNavigationPage()),
    GetPage(name: Routes.profile, page: () => const ProfilePage()),
    GetPage(name: Routes.firstRegister, page: () => const FirstRegisterPage()),
    GetPage(name: Routes.createApartment, page: () => const CreateApartment()),
    GetPage(
      name: Routes.apartmentDetails,
      page: () => ApartmentDetailsPage(),
      binding: BindingsBuilder(() {
        final arg = Get.arguments;
        if (arg is ApartmentModel) {
          Get.put(ApartmentController(arg));
        } else {
          Get.put(ApartmentController(null));
        }
      }),
    ),
    GetPage(
      name: Routes.secondRegister,
      page: () => SecondRegisterPage(
        role: Get.arguments['role'],
        mobile: Get.arguments['mobile'],
        password: Get.arguments['password'],
      ),
    ),
  ];
}
