import 'package:get/get.dart';
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
    print(myApartments);
    super.onInit();
  }

  Future<void> fetchMyApartments() async {
    isLoading.value = true;
    final response = await service.getLandlordApartments();
    myApartments.value = response;
    isLoading.value = false;
  }
}
