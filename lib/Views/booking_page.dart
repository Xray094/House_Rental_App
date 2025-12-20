import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Views/Login&Register/login_page.dart';
import 'package:house_rental_app/core/colors/color.dart';
import 'package:house_rental_app/core/controllers/booking_controller.dart';
import 'package:house_rental_app/routes/app_routes.dart';

import 'package:intl/intl.dart';

class BookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(BookingController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
        backgroundColor: primaryBlue,
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ctrl.myBookings.isEmpty) {
          return const Center(child: Text("No bookings found."));
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
                statusColor = Colors.green;
                break;
              case 'pending':
                statusColor = Colors.orange;
                break;
              case 'cancelled':
              case 'canceled':
                statusColor = Colors.red;
                break;
              default:
                statusColor = Colors.grey;
            }

            return Card(
              elevation: 5,
              child: ListTile(
                minTileHeight: 20,
                onTap:
                    (booking.status.toLowerCase() == 'cancelled' ||
                        (booking.apartmentId.isEmpty &&
                            booking.apartment == null))
                    ? null
                    : () => Get.toNamed(
                        Routes.apartmentDetails,
                        arguments: booking.apartment ?? booking.apartmentId,
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
                          onPressed: () => _showReviewDialog(booking.id),
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
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                                size: 20,
                              ),
                              onPressed: () =>
                                  ctrl.editBookingDates(context, booking),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
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
}

void _showReviewDialog(String bookingId) {
  final TextEditingController reviewController = TextEditingController();
  final RxDouble selectedRating = 5.0.obs;

  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.black,
      title: Text("Rate your stay", style: TextStyle(color: primaryBlue)),
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
          style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
          onPressed: () {
            if (reviewController.text.trim().isEmpty) {
              Get.snackbar("Required", "Please write a comment.");
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
          child: const Text("Submit", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
    barrierDismissible: true,
  );
}
