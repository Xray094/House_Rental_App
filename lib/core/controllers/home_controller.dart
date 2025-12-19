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

  Future<void> loadApartments({bool forceRefresh = false}) async {
    try {
      isLoading.value = true;
      error.value = null;
      final list = await _repo.getApartments(forceRefresh: forceRefresh);
      apartments.assignAll(list);
    } catch (e) {
      error.value = e.toString();
      apartments.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
