import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Services/apartment_repository.dart';

class HomeController extends GetxController {
  final ApartmentRepository _repo = Get.find<ApartmentRepository>();

  final apartments = <ApartmentModel>[].obs;
  final isLoading = false.obs;
  final error = Rxn<String>();

  // Filter variables
  final selectedGovernorate = Rxn<String>();
  final selectedCity = Rxn<String>();
  final minPrice = Rxn<double>();
  final maxPrice = Rxn<double>();
  final minRooms = Rxn<int>();
  final minArea = Rxn<int>();
  final isFiltersVisible = false.obs;

  // Computed property for filtered apartments
  List<ApartmentModel> get filteredApartments {
    return apartments.where((apartment) {
      final attr = apartment.attributes;

      // Governorate filter
      if (selectedGovernorate.value != null &&
          attr.location.governorate != selectedGovernorate.value) {
        return false;
      }

      // City filter
      if (selectedCity.value != null &&
          attr.location.city != selectedCity.value) {
        return false;
      }

      // Price filters
      if (minPrice.value != null && attr.price < minPrice.value!) {
        return false;
      }
      if (maxPrice.value != null && attr.price > maxPrice.value!) {
        return false;
      }

      // Room filter
      if (minRooms.value != null && attr.specs.rooms < minRooms.value!) {
        return false;
      }

      // Area filter
      if (minArea.value != null && attr.specs.area < minArea.value!) {
        return false;
      }

      return true;
    }).toList();
  }

  // Filter methods
  void setGovernorate(String? governorate) {
    selectedGovernorate.value = governorate;
    // Reset city when governorate changes
    if (governorate != selectedGovernorate.value) {
      selectedCity.value = null;
    }
  }

  void setCity(String? city) {
    selectedCity.value = city;
  }

  void setMinPrice(double? price) {
    minPrice.value = price;
  }

  void setMaxPrice(double? price) {
    maxPrice.value = price;
  }

  void setMinRooms(int? rooms) {
    minRooms.value = rooms;
  }

  void setMinArea(int? area) {
    minArea.value = area;
  }

  void clearFilters() {
    selectedGovernorate.value = null;
    selectedCity.value = null;
    minPrice.value = null;
    maxPrice.value = null;
    minRooms.value = null;
    minArea.value = null;
  }

  void toggleFilters() {
    isFiltersVisible.value = !isFiltersVisible.value;
  }

  @override
  void onInit() {
    super.onInit();
    loadApartments();
  }

  Future<void> loadApartments() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      error.value = null;

      final list = await _repo.getApartments();
      if (list.isNotEmpty || apartments.isEmpty) {
        apartments.assignAll(list);
      }
    } catch (e) {
      if (e.toString().contains("FormatException")) {
        error.value = "Data was incomplete. Please try again.";
      } else {
        error.value = "Check your internet connection";
      }
      print("Home Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
