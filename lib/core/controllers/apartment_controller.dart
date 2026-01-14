import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Services/apartment_service.dart';
import 'package:house_rental_app/Services/favorites_service.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Services/booking_service.dart';

class ApartmentController extends GetxController {
  final ApartmentModel? initialApt;
  ApartmentController(this.initialApt);

  final BookingService _bookingService = Get.find<BookingService>();
  final GetStorage _box = GetStorage();

  var apartment = Rxn<ApartmentModel>();
  var isFavorite = false.obs;
  var isBooking = false.obs;
  var apartmentService = ApartmentService();

  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  final isLoading = false.obs;

  final FavoritesService _favoritesService = Get.put(FavoritesService());

  @override
  void onInit() {
    super.onInit();
    if (initialApt != null) {
      apartment.value = initialApt;
    }
  }

  bool get isTenant => _box.read('role') == 'tenant';

  Future<bool> toggleFavorite(String apartmentId) async {
    try {
      final result = await _favoritesService.toggleFavorite(apartmentId);
      return result;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update favorite status',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.black,
      );
      return false;
    }
  }

  Future<void> pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: startDate.value != null && endDate.value != null
          ? DateTimeRange(start: startDate.value!, end: endDate.value!)
          : null,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      startDate.value = picked.start;
      endDate.value = picked.end;
    }
  }

  Future<void> loadDetails(String id) async {
    isLoading(true);
    final result = await apartmentService.getApartmentById(id);
    apartment.value = result;

    isFavorite.value = await _favoritesService.isFavorite(id);
    print(isFavorite.value);
    isLoading(false);
  }

  double get totalPrice {
    if (startDate.value == null || endDate.value == null) return 0.0;
    int nights = endDate.value!.difference(startDate.value!).inDays;
    return nights * (apartment.value?.attributes.price ?? 0.0);
  }

  Future<String?> book() async {
    if (startDate.value == null || endDate.value == null) {
      return "Please select rental dates first";
    }

    isBooking.value = true;
    try {
      final result = await _bookingService.storeBooking(
        apartmentId: apartment.value!.id,
        startDate: DateFormat('yyyy-MM-dd').format(startDate.value!),
        endDate: DateFormat('yyyy-MM-dd').format(endDate.value!),
      );

      isBooking.value = false;
      if (result == true) return null;

      return "This time slot is already booked. Please choose different dates.";
    } catch (e) {
      isBooking.value = false;
      return e.toString().replaceAll('Exception: ', '');
    }
  }
}
