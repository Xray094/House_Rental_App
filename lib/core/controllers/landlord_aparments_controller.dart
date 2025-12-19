import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Services/apartment_service.dart';
import 'package:house_rental_app/core/controllers/auth_controller.dart';

class LandlordApartmentsController extends GetxController {
  final ApartmentService service = Get.find<ApartmentService>();
  final AuthController authC = Get.find<AuthController>();
  var myApartments = <ApartmentModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchMyApartments();
    super.onInit();
  }

  Future<void> fetchMyApartments() async {
    isLoading.value = true;
    // Assuming your API supports filtering by owner or has a specific 'my' endpoint
    final response = await service.getLandlordApartments(authC.user.value!.id);
    myApartments.value = response;
    isLoading.value = false;
  }
}
