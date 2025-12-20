import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Models/booking_model.dart';
import 'package:intl/intl.dart';

class ApartmentBookingsPage extends StatelessWidget {
  const ApartmentBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ApartmentModel apartment = Get.arguments;
    final List<BookingModel> bookings = apartment.bookings;

    return Scaffold(
      appBar: AppBar(title: Text("Bookings: ${apartment.attributes.title}")),
      body: bookings.isEmpty
          ? const Center(child: Text("No requests for this apartment"))
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin: EdgeInsets.all(10.w),
                  child: ListTile(
                    title: Text("Guest Request #${booking.id}"),
                    subtitle: Text(
                      "Dates: ${DateFormat('yyyy-MM-dd').format(booking.startDate)} to ${DateFormat('yyyy-MM-dd').format(booking.endDate)}\nTotal: ${booking.totalPriceFormatted}",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            /* Call Approve API */
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {
                            /* Call Cancel API */
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
