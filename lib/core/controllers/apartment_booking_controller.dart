import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Services/booking_service.dart';
import 'package:house_rental_app/core/colors/color.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';

class ApartmentBookingController extends GetxController {
  BookingService bookingService = Get.find<BookingService>();

  void approveBooking(String bookingId, BuildContext context) async {
    final Map<String, dynamic> res = await bookingService.approveBooking(
      bookingId,
    );
    if (res['success'] == true) {
      Get.back(result: true);
      Get.snackbar(
        'Success',
        res['message'] ?? 'Booking approved',
        backgroundColor: LightThemeColors.success,
        colorText: context.currentButtonPrimaryText,
        snackPosition: SnackPosition.TOP,
      );
    } else {
      final msg = (res['message'] ?? 'Failed to approve booking').toString();
      Get.dialog(
        AlertDialog(
          title: const Text('Approve Failed'),
          content: Text(msg),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('OK')),
          ],
        ),
      );
    }
  }

  void rejectBooking(String bookingId, BuildContext context) async {
    final Map<String, dynamic> res = await bookingService.cancelBooking(
      bookingId,
    );
    if (res['success'] == true) {
      Get.back(result: true);
      Get.snackbar(
        'Success',
        res['message'] ?? 'Booking rejected',
        backgroundColor: LightThemeColors.success,
        colorText: context.currentButtonPrimaryText,
        snackPosition: SnackPosition.TOP,
      );
    } else {
      final msg = (res['message'] ?? 'Failed to reject booking').toString();
      Get.dialog(
        AlertDialog(
          title: const Text('Reject Failed'),
          content: Text(msg),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('OK')),
          ],
        ),
      );
    }
  }
}
