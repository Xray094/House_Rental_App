import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/core/colors/color.dart';
import 'package:intl/intl.dart';
import 'package:house_rental_app/Models/booking_model.dart';
import 'package:house_rental_app/Services/booking_service.dart';

class BookingController extends GetxController {
  var myBookings = <BookingModel>[].obs;
  var isLoading = false.obs;

  final BookingService bookingService = Get.find<BookingService>();

  @override
  void onInit() {
    fetchMyBookings();
    super.onInit();
  }

  Future<void> fetchMyBookings() async {
    isLoading.value = true;
    final List<dynamic> raw = await bookingService.getUserBookings();
    final parsed = raw
        .where((e) => e != null)
        .map<BookingModel>(
          (e) => BookingModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
    myBookings.value = parsed;
    isLoading.value = false;
  }

  Future<void> submitReview({
    required String apartmentId,
    required String bookingId,
    required String comment,
    required double rating,
  }) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final Map<String, dynamic> result = await bookingService.submitReview(
        apartmentId: apartmentId,
        bookingId: bookingId,
        comment: comment,
        rating: rating.toInt().toString(),
      );
      Get.back();
      if (result['success'] == true) {
        Get.snackbar(
          "Success",
          result['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        fetchMyBookings();
      } else {
        Get.snackbar(
          "Review Failed",
          result['message'],
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      Get.back();
      print("Controller Review Error: $e");
    }
  }

  Future<void> editBookingDates(
    BuildContext context,
    BookingModel booking,
  ) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        final ThemeData theme = Theme.of(context);
        final bool isDark = theme.brightness == Brightness.dark;
        final ColorScheme scheme = isDark
            ? ColorScheme.dark(
                primary: primaryBlue,
                onPrimary: Colors.white,
                surface: theme.colorScheme.surface,
                onSurface: Colors.white,
              )
            : ColorScheme.light(
                primary: primaryBlue,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black87,
              );
        final DatePickerThemeData datePickerTheme = DatePickerThemeData(
          headerBackgroundColor: primaryBlue,
          headerForegroundColor: Colors.white,
          backgroundColor: isDark ? theme.dialogBackgroundColor : Colors.white,
          dayShape: WidgetStateProperty.all(const CircleBorder()),
          rangeSelectionBackgroundColor: primaryBlue.withOpacity(0.12),
          rangeSelectionOverlayColor: WidgetStateProperty.all(
            primaryBlue.withOpacity(0.1),
          ),
          confirmButtonStyle: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(primaryBlue),
            textStyle: WidgetStateProperty.all(
              TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
          ),
        );

        return Theme(
          data: theme.copyWith(
            colorScheme: scheme,
            datePickerTheme: datePickerTheme,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: primaryBlue),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final start = DateFormat('yyyy-MM-dd').format(picked.start);
      final end = DateFormat('yyyy-MM-dd').format(picked.end);

      final Map<String, dynamic> res = await bookingService.updateBooking(
        bookingId: booking.id,
        startDate: start,
        endDate: end,
      );

      Get.back();

      if (res['success'] == true) {
        Get.snackbar(
          'Success',
          res['message'] ?? 'Booking updated',
          snackPosition: SnackPosition.TOP,
        );
        fetchMyBookings();
      } else {
        final msg = (res['message'] ?? 'Failed to update booking').toString();
        Get.dialog(
          AlertDialog(
            title: const Text('Update Failed'),
            content: Text(msg),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('OK')),
            ],
          ),
        );
      }
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    final confirmed = await Get.defaultDialog<bool>(
      title: "Cancel Booking",
      titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      middleText: "Are you sure you want to cancel this booking?",
      middleTextStyle: TextStyle(color: Colors.black),
      textConfirm: "Yes, Cancel",
      confirmTextColor: Colors.black,
      textCancel: "No",
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirmed == true) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final Map<String, dynamic> res = await bookingService.cancelBooking(
        bookingId,
      );
      Get.back();
      if (res['success'] == true) {
        Get.snackbar(
          'Success',
          res['message'] ?? 'Booking cancelled',
          snackPosition: SnackPosition.TOP,
        );
        fetchMyBookings();
      } else {
        final msg = (res['message'] ?? 'Failed to cancel booking').toString();
        Get.dialog(
          AlertDialog(
            title: const Text('Cancel Failed'),
            content: Text(msg),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('OK')),
            ],
          ),
        );
      }
    }
  }
}
