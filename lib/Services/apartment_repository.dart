import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Services/apartment_service.dart';

class ApartmentRepository extends GetxService {
  final ApartmentService _service = Get.find<ApartmentService>();
  final apartments = <ApartmentModel>[].obs;

  Future<List<ApartmentModel>> getApartments() async {
    try {
      final list = await _service.getApartments();
      apartments.assignAll(list);
      return apartments;
    } catch (e) {
      rethrow;
    }
  }

  void clearCache() {
    apartments.clear();
  }
}
