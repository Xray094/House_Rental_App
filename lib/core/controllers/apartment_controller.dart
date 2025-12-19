import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';

class ApartmentController extends GetxController {
  final Rxn<ApartmentModel> apartment = Rxn<ApartmentModel>();

  final isBooking = false.obs;
  final isFavorite = false.obs;

  ApartmentController(ApartmentModel initial) {
    apartment.value = initial;
  }

  Future<bool> book() async {
    try {
      isBooking.value = true;
      // TODO: replace with real API call via a BookingService
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      print('Booking Error: $e');
      return false;
    } finally {
      isBooking.value = false;
    }
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }
}
