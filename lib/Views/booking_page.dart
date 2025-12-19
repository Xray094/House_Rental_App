import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/core/colors/color.dart';
import 'package:house_rental_app/core/controllers/booking_controller.dart';
import 'package:house_rental_app/routes/app_routes.dart';

import 'package:intl/intl.dart';

class MyBookingsPage extends StatelessWidget {
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

            // Use total price from booking (already provided by API)
            final priceText = booking.totalPriceFormatted.isNotEmpty
                ? booking.totalPriceFormatted
                : NumberFormat('#,##0.00').format(booking.totalPrice);

            Color statusColor;
            switch (booking.status.toLowerCase()) {
              case 'approved':
              case 'confirmed':
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
              child: ListTile(
                onTap:
                    (booking.status.toLowerCase() == 'cancelled' ||
                        booking.status.toLowerCase() == 'canceled' ||
                        booking.apartment == null)
                    ? null
                    : () => Get.toNamed(
                        Routes.apartmentDetails,
                        arguments: booking.apartment,
                      ),
                leading: booking.gallery.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(booking.gallery.first),
                        radius: 28,
                      )
                    : const CircleAvatar(child: Icon(Icons.home_outlined)),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        booking.apartmentTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
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
                        style: TextStyle(color: statusColor, fontSize: 12.sp),
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
                      '${booking.nightsCount} night(s) · ${priceText}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                isThreeLine: true,
                trailing:
                    (booking.status.toLowerCase() == 'cancelled' ||
                        booking.status.toLowerCase() == 'canceled')
                    ? null
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () =>
                                ctrl.editBookingDates(context, booking),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => ctrl.cancelBooking(booking.id),
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
