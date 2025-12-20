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
          (e) => BookingModel.fromApiJson(e as Map<String, dynamic>),
        )
        .toList();
    myBookings.value = parsed;
    isLoading.value = false;
  }

  Future<void> editBookingDates(
    BuildContext context,
    BookingModel booking,
  ) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: booking.startDate,
        end: booking.endDate,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            // 1. Controls general color scheme (Headers/Selection)
            colorScheme: ColorScheme.light(
              primary: primaryBlue,
              onPrimary: Colors.black,
              onSurface: Colors.black, // This controls the active month numbers
            ),
            // 2. Controls the specific look of the calendar grid
            datePickerTheme: DatePickerThemeData(
              // Background of the entire picker
              backgroundColor: Colors.black,

              // Style for the numbers (Day text)
              dayStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),

              // This ensures January numbers aren't faint/greyed out
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.black; // Selected text color
                }
                if (states.contains(WidgetState.disabled)) {
                  return Colors.grey.shade400; // Dates outside your range
                }
                return Colors.black; // Default color for all other numbers
              }),

              // Controls the faint purple background color in your screenshot
              rangeSelectionBackgroundColor: primaryBlue.withOpacity(0.15),
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

      Get.back(); // Close loading

      if (res['success'] == true) {
        Get.snackbar(
          'Success',
          res['message'] ?? 'Booking updated',
          snackPosition: SnackPosition.BOTTOM,
        );
        fetchMyBookings(); // Refresh list
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

  // Cancel Logic
  Future<void> cancelBooking(String bookingId) async {
    final confirmed = await Get.defaultDialog<bool>(
      title: "Cancel Booking",
      titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      middleText: "Are you sure you want to cancel this booking?",
      middleTextStyle: TextStyle(color: Colors.black),
      textConfirm: "Yes, Cancel",
      confirmTextColor: Colors.white,
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
      Get.back(); // close loading
      if (res['success'] == true) {
        Get.snackbar(
          'Success',
          res['message'] ?? 'Booking cancelled',
          snackPosition: SnackPosition.BOTTOM,
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
