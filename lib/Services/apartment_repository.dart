import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Services/apartment_service.dart';

class ApartmentRepository extends GetxService {
  final ApartmentService _service = Get.find<ApartmentService>();

  final apartments = <ApartmentModel>[].obs;

  Future<List<ApartmentModel>> getApartments({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && apartments.isNotEmpty) {
      return apartments;
    }

    final list = await _service.getApartments();
    apartments.assignAll(list);
    // do not persist list - keep in memory only
    return apartments;
  }

  void clearCache() {
    apartments.clear();
  }
}
