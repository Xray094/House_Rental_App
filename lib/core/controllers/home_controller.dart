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

  final availableGovernorates = <String>[].obs;
  final availableCities = <String>[].obs;
  final isLoadingFilters = false.obs;

  List<ApartmentModel> get filteredApartments {
    return apartments.where((apartment) {
      final attr = apartment.attributes;

      if (selectedGovernorate.value != null &&
          attr.location.governorate != selectedGovernorate.value) {
        return false;
      }

      if (selectedCity.value != null &&
          attr.location.city != selectedCity.value) {
        return false;
      }

      if (minPrice.value != null && attr.price < minPrice.value!) {
        return false;
      }
      if (maxPrice.value != null && attr.price > maxPrice.value!) {
        return false;
      }

      if (minRooms.value != null && attr.specs.rooms < minRooms.value!) {
        return false;
      }

      if (minArea.value != null && attr.specs.area < minArea.value!) {
        return false;
      }

      return true;
    }).toList();
  }

  void setGovernorate(String? governorate) {
    selectedGovernorate.value = governorate;
    if (governorate != selectedGovernorate.value) {
      selectedCity.value = null;
    }
    loadApartments();
  }

  void setCity(String? city) {
    selectedCity.value = city;
    loadApartments();
  }

  void setMinPrice(double? price) {
    minPrice.value = price;
    loadApartments();
  }

  void setMaxPrice(double? price) {
    maxPrice.value = price;
    loadApartments();
  }

  void setMinRooms(int? rooms) {
    minRooms.value = rooms;
    loadApartments();
  }

  void setMinArea(int? area) {
    minArea.value = area;
    loadApartments();
  }

  void clearFilters() {
    selectedGovernorate.value = null;
    selectedCity.value = null;
    minPrice.value = null;
    maxPrice.value = null;
    minRooms.value = null;
    minArea.value = null;
    loadApartments();
  }

  void toggleFilters() {
    isFiltersVisible.value = !isFiltersVisible.value;
  }

  @override
  void onInit() {
    super.onInit();
    loadFilterOptions();
    loadApartments();
  }

  Future<void> loadFilterOptions() async {
    try {
      isLoadingFilters.value = true;
      final result = await service.getFilterOptions();

      availableGovernorates.assignAll(result['governorates'] as List<String>);
      availableCities.assignAll(result['cities'] as List<String>);
    } catch (e) {
      print("Error loading filter options: $e");
    } finally {
      isLoadingFilters.value = false;
    }
  }

  Future<void> loadApartments() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      error.value = null;

      currentPage.value = 1;
      hasMorePages.value = true;
      apartments.clear();

      await loadFilterOptions();

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

      apartments.addAll(fetchedApartments);
      hasMorePages.value = result['hasMore'] as bool;
      currentPage.value = nextPage;
      totalApartments.value = result['total'] as int;
    } catch (e) {
      print("Error loading more apartments: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }
}
