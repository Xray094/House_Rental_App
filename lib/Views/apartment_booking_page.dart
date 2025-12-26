import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Models/booking_model.dart';
import 'package:house_rental_app/Services/booking_service.dart';
import 'package:house_rental_app/core/colors/color.dart';
import 'package:intl/intl.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';

class ApartmentBookingsPage extends StatelessWidget {
  const ApartmentBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ApartmentModel apartment = Get.arguments;
    final List<BookingModel> bookings = apartment.bookings;
    final BookingService bookingService = Get.find<BookingService>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Bookings: ${apartment.attributes.title}"),
        backgroundColor: context.primary,
      ),
      body: bookings.isEmpty
          ? Center(
              child: Text(
                "No requests for this apartment",
                style: TextStyle(color: context.currentTextSecondary),
              ),
            )
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final bool canTakeAction =
                    booking.status.toLowerCase() == 'pending';

                return Card(
                  margin: EdgeInsets.all(10.w),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Booking #${booking.id}",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: context.primary,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  booking.status,
                                ).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: _getStatusColor(
                                    booking.status,
                                  ).withOpacity(0.4),
                                ),
                              ),
                              child: Text(
                                booking.status.toUpperCase(),
                                style: TextStyle(
                                  color: _getStatusColor(booking.status),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Dates: ${DateFormat('MMM d, yyyy').format(booking.startDate)} to ${DateFormat('MMM d, yyyy').format(booking.endDate)}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: context.currentTextSecondary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Duration: ${booking.nightsCount} night(s)",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: context.currentTextSecondary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Total: ${booking.totalPriceFormatted}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: LightThemeColors.success,
                          ),
                        ),
                        if (canTakeAction)
                          Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _handleApprove(
                                    context,
                                    booking.id,
                                    bookingService,
                                  ),
                                  icon: Icon(
                                    Icons.check_circle,
                                    size: 18.sp,
                                    color: context.currentButtonPrimaryText,
                                  ),
                                  label: Text(
                                    "Approve",
                                    style: TextStyle(
                                      color: context.currentButtonPrimaryText,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: LightThemeColors.success,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 8.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                ElevatedButton.icon(
                                  onPressed: () => _handleReject(
                                    context,
                                    booking.id,
                                    bookingService,
                                  ),
                                  icon: Icon(
                                    Icons.cancel,
                                    size: 18.sp,
                                    color: context.currentButtonPrimaryText,
                                  ),
                                  label: Text(
                                    "Reject",
                                    style: TextStyle(
                                      color: context.currentButtonPrimaryText,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: LightThemeColors.error,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 8.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  static Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return LightThemeColors.success;
      case 'pending':
        return LightThemeColors.warning;
      case 'rejected':
      case 'cancelled':
      case 'canceled':
        return LightThemeColors.error;
      case 'completed':
        return LightThemeColors.info;
      default:
        return LightThemeColors.textSecondary;
    }
  }

  static void _handleApprove(
    BuildContext context,
    String bookingId,
    BookingService bookingService,
  ) async {
    final confirmed = await Get.defaultDialog<bool>(
      title: "Approve Booking",
      titleStyle: TextStyle(
        color: context.currentTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      middleText: "Are you sure you want to approve this booking?",
      middleTextStyle: TextStyle(color: context.currentTextSecondary),
      textConfirm: "Yes, Approve",
      confirmTextColor: context.currentButtonPrimaryText,
      textCancel: "No",
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirmed == true) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final Map<String, dynamic> res = await bookingService.approveBooking(
        bookingId,
      );

      Get.back();

      if (res['success'] == true) {
        Get.snackbar(
          'Success',
          res['message'] ?? 'Booking approved',
          backgroundColor: LightThemeColors.success,
          colorText: context.currentButtonPrimaryText,
          snackPosition: SnackPosition.BOTTOM,
        );
        // Refresh the page by popping and navigating back
        Get.back();
        Get.to(() => const ApartmentBookingsPage());
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
  }

  static void _handleReject(
    BuildContext context,
    String bookingId,
    BookingService bookingService,
  ) async {
    final confirmed = await Get.defaultDialog<bool>(
      title: "Reject Booking",
      titleStyle: TextStyle(
        color: context.currentTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      middleText: "Are you sure you want to reject this booking?",
      middleTextStyle: TextStyle(color: context.currentTextSecondary),
      textConfirm: "Yes, Reject",
      confirmTextColor: context.currentButtonPrimaryText,
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
          res['message'] ?? 'Booking rejected',
          backgroundColor: LightThemeColors.error,
          colorText: context.currentButtonPrimaryText,
          snackPosition: SnackPosition.BOTTOM,
        );
        // Refresh the page by popping and navigating back
        Get.back();
        Get.to(() => const ApartmentBookingsPage());
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
}
