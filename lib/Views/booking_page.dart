import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/core/controllers/booking_controller.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';
import 'package:house_rental_app/core/colors/color.dart';
import 'package:house_rental_app/routes/app_routes.dart';

import 'package:intl/intl.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(BookingController());

    return Scaffold(
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ctrl.myBookings.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          itemCount: ctrl.myBookings.length,
          padding: EdgeInsets.all(16.w),
          itemBuilder: (context, index) {
            final booking = ctrl.myBookings[index];
            final priceText = booking.totalPriceFormatted;
            Color statusColor;
            switch (booking.status.toLowerCase()) {
              case 'approved':
              case 'completed':
                statusColor = LightThemeColors.success;
                break;
              case 'pending':
                statusColor = LightThemeColors.warning;
                break;
              case 'cancelled':
                statusColor = LightThemeColors.error;
                break;
              default:
                statusColor = context.currentTextSecondary;
            }

            return Card(
              elevation: 5,
              child: ListTile(
                minTileHeight: 20,
                onTap: () => Get.toNamed(
                  Routes.apartmentDetails,
                  arguments: booking.apartment,
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        booking.apartmentTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${DateFormat('MMM d').format(booking.startDate)} - ${DateFormat('MMM d').format(booking.endDate)}",
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${booking.nightsCount} night(s) · $priceText',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                isThreeLine: true,
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor.withOpacity(0.4)),
                      ),
                      child: Text(
                        booking.status.toUpperCase(),
                        style: TextStyle(color: statusColor, fontSize: 10.sp),
                      ),
                    ),
                    if (booking.status.toLowerCase() == 'completed')
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () =>
                              _showReviewDialog(context, booking.id),
                          icon: Icon(
                            Icons.star_rate,
                            size: 16.sp,
                            color: Colors.amber,
                          ),
                          label: Text(
                            "Review",
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ),
                      )
                    else if (booking.status.toLowerCase() == 'pending')
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: LightThemeColors.warning,
                                size: 20,
                              ),
                              onPressed: () =>
                                  ctrl.editBookingDates(context, booking),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: LightThemeColors.error,
                                size: 20,
                              ),
                              onPressed: () => ctrl.cancelBooking(booking.id),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month,
              size: 80.sp,
              color: context.currentTextSecondary,
            ),
            SizedBox(height: 24.h),
            Text(
              'No Bookings Yet',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: context.currentTextPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Browse apartments and book your first stay!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: context.currentTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showReviewDialog(BuildContext context, String bookingId) {
  final TextEditingController reviewController = TextEditingController();
  final RxDouble selectedRating = 5.0.obs;

  Get.dialog(
    AlertDialog(
      backgroundColor: context.currentSurfaceColor,
      title: Text("Rate your stay", style: TextStyle(color: context.primary)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < selectedRating.value
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () => selectedRating.value = index + 1.0,
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: reviewController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Tell us about your experience...",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: context.currentButtonPrimary,
          ),
          onPressed: () {
            if (reviewController.text.trim().isEmpty) {
              Get.snackbar(
                "Required",
                "Please write a comment.",
                snackPosition: SnackPosition.TOP,
              );
              return;
            }

            final bookingCtrl = Get.find<BookingController>();
            final booking = bookingCtrl.myBookings.firstWhere(
              (b) => b.id == bookingId,
            );

            bookingCtrl.submitReview(
              apartmentId: booking.apartmentId,
              bookingId: bookingId,
              comment: reviewController.text.trim(),
              rating: selectedRating.value,
            );

            Get.back();
          },
          child: Text(
            "Submit",
            style: TextStyle(color: context.currentButtonPrimaryText),
          ),
        ),
      ],
    ),
    barrierDismissible: true,
  );
}
