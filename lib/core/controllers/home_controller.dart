import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Services/apartment_repository.dart';

class HomeController extends GetxController {
  final ApartmentRepository _repo = Get.find<ApartmentRepository>();

  final apartments = <ApartmentModel>[].obs;
  final isLoading = false.obs;
  final error = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadApartments();
  }

  Future<void> loadApartments() async {
    // Prevent multiple simultaneous calls
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      error.value = null;

      final list = await _repo.getApartments();

      // Update list only if valid data returned
      if (list.isNotEmpty || apartments.isEmpty) {
        apartments.assignAll(list);
      }
    } catch (e) {
      // Catch specific FormatException or general errors
      if (e.toString().contains("FormatException")) {
        error.value = "Data was incomplete. Please try again.";
      } else {
        error.value = "Check your internet connection";
      }
      print("Home Fetch Error: $e");
    } finally {
      // Ensuring loading stops regardless of success or failure
      isLoading.value = false;
    }
  }
}
