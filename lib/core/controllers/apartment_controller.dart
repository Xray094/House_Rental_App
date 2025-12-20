import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/user_model.dart';
import 'package:house_rental_app/Services/apartment_service.dart';
import 'package:house_rental_app/Services/auth_service.dart';
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

  @override
  void onInit() {
    super.onInit();
    if (initialApt != null) {
      apartment.value = initialApt;
    }
  }

  bool get isTenant => _box.read('role') == 'tenant';

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
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
    isLoading(false);
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
