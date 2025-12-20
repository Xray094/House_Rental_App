import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Views/apartment_booking_page.dart';
import 'package:house_rental_app/core/colors/color.dart';
import 'package:house_rental_app/core/controllers/landlord_aparments_controller.dart';

class LandlordApartmentsPage extends StatelessWidget {
  const LandlordApartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<LandlordApartmentsController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (ctrl.isLoading.value && ctrl.myApartments.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ctrl.myApartments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No apartments found."),
                TextButton(
                  onPressed: () => ctrl.fetchMyApartments(),
                  child: const Text("Refresh"),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ctrl.fetchMyApartments(),
          child: ListView.builder(
            padding: EdgeInsets.all(15.w),
            itemCount: ctrl.myApartments.length,
            itemBuilder: (context, index) {
              final apartment = ctrl.myApartments[index];
              final attr = apartment.attributes;
              final int bookingCount = apartment.bookings.length;

              return Card(
                margin: EdgeInsets.only(bottom: 20.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                clipBehavior: Clip.antiAlias,
                elevation: 3,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          attr.galleryUrls.isNotEmpty
                              ? attr.galleryUrls.first
                              : 'https://via.placeholder.com/160',
                          height: 180.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        if (bookingCount > 0)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () => Get.to(
                                () => ApartmentBookingsPage(),
                                arguments: apartment,
                              ),
                              child: CircleAvatar(
                                radius: 15.r,
                                backgroundColor: Colors.red,
                                child: Text(
                                  bookingCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  attr.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                    color: primaryBlue,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blueGrey,
                                    ),
                                    onPressed: () {
                                      //not now
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () =>
                                        ctrl.deleteApartment(apartment.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16.sp,
                                color: Colors.grey,
                              ),
                              Text(
                                "${attr.location.city}, ${attr.location.governorate}",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
