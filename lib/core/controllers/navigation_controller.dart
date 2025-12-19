import 'package:get/get.dart';
import 'package:house_rental_app/Models/user_model.dart';

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
      user.value = Get.find<UserModel>();
      print(user.value);
    }
  }

  void changeIndex(int index) {
    print(selectedIndex.value);
    selectedIndex.value = index;
    print(selectedIndex);
  }

  // Helper getter to check role safely
  bool get isTenant => user.value?.attributes.role == 'tenant';
}
