import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Models/booking_model.dart';
import 'package:house_rental_app/core/colors/color.dart';
import 'package:house_rental_app/core/controllers/apartment_booking_controller.dart';
import 'package:intl/intl.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';

class ApartmentBookingsPage extends StatelessWidget {
  const ApartmentBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ApartmentModel apartment = Get.arguments;
    final List<BookingModel> bookings = apartment.bookings;
    final ApartmentBookingController controller =
        Get.find<ApartmentBookingController>();

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
                          "Name: ",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: LightThemeColors.success,
                          ),
                        ),
                        SizedBox(height: 4.h),
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
                                  onPressed: () => controller.approveBooking(
                                    booking.id,
                                    context,
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
                                  onPressed: () => controller.rejectBooking(
                                    booking.id,
                                    context,
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
}
