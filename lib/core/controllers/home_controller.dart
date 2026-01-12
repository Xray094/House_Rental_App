import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Services/apartment_service.dart';

class HomeController extends GetxController {
  final ApartmentService service = Get.find<ApartmentService>();

  final apartments = <ApartmentModel>[].obs;
  final isLoading = false.obs;
  final error = Rxn<String>();

  final currentPage = 1.obs;
  final hasMorePages = true.obs;
  final isLoadingMore = false.obs;
  final totalApartments = 0.obs;

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
    // Reload apartments with new filter
    loadApartments();
  }

  void setCity(String? city) {
    selectedCity.value = city;
    // Reload apartments with new filter
    loadApartments();
  }

  void setMinPrice(double? price) {
    minPrice.value = price;
    // Reload apartments with new filter
    loadApartments();
  }

  void setMaxPrice(double? price) {
    maxPrice.value = price;
    // Reload apartments with new filter
    loadApartments();
  }

  void setMinRooms(int? rooms) {
    minRooms.value = rooms;
    // Reload apartments with new filter
    loadApartments();
  }

  void setMinArea(int? area) {
    minArea.value = area;
    // Reload apartments with new filter
    loadApartments();
  }

  void clearFilters() {
    selectedGovernorate.value = null;
    selectedCity.value = null;
    minPrice.value = null;
    maxPrice.value = null;
    minRooms.value = null;
    minArea.value = null;
    // Reload apartments after clearing filters
    loadApartments();
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

      // Reset pagination state
      currentPage.value = 1;
      hasMorePages.value = true;
      apartments.clear();

      // Fetch with pagination and filters
      final result = await service.getApartmentsWithPagination(
        page: 1,
        governorate: selectedGovernorate.value,
        city: selectedCity.value,
        minPrice: minPrice.value,
        maxPrice: maxPrice.value,
        minRooms: minRooms.value,
        minArea: minArea.value,
        perPage: 10,
      );

      final List<ApartmentModel> fetchedApartments =
          result['apartments'] as List<ApartmentModel>;
      apartments.assignAll(fetchedApartments);
      hasMorePages.value = result['hasMore'] as bool;
      totalApartments.value = result['total'] as int;
    } catch (e) {
      error.value =
          "Connection is unstable. Please check your internet and pull to refresh.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreApartments() async {
    // Prevent multiple simultaneous loads
    if (isLoadingMore.value || !hasMorePages.value) return;

    try {
      isLoadingMore.value = true;

      final nextPage = currentPage.value + 1;
      final result = await service.getApartmentsWithPagination(
        page: nextPage,
        governorate: selectedGovernorate.value,
        city: selectedCity.value,
        minPrice: minPrice.value,
        maxPrice: maxPrice.value,
        minRooms: minRooms.value,
        minArea: minArea.value,
        perPage: 10,
      );

      final List<ApartmentModel> fetchedApartments =
          result['apartments'] as List<ApartmentModel>;

      // Append new apartments to the list
      apartments.addAll(fetchedApartments);
      hasMorePages.value = result['hasMore'] as bool;
      currentPage.value = nextPage;
      totalApartments.value = result['total'] as int;
    } catch (e) {
      // Silent fail for load more - don't show error for pagination failures
      print("Error loading more apartments: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }
}
