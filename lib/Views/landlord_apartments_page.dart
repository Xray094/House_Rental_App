import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Views/apartment_booking_page.dart';
import 'package:house_rental_app/core/controllers/landlord_aparments_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';
import 'package:house_rental_app/routes/app_routes.dart';

class LandlordApartmentsPage extends StatelessWidget {
  const LandlordApartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<LandlordApartmentsController>();

    return Scaffold(
      backgroundColor: context.currentBackgroundColor,
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
                        CachedNetworkImage(
                          imageUrl: attr.galleryUrls.isNotEmpty
                              ? attr.galleryUrls.first
                              : "https://via.placeholder.com/160",
                          height: 180.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Container(
                                height: 180.h,
                                width: double.infinity,
                                color: context.currentSurfaceColor,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    color: context.primary,
                                  ),
                                ),
                              ),
                          memCacheHeight: 360,
                          maxWidthDiskCache: 800,
                          errorWidget: (context, url, error) => Container(
                            color: context.currentSurfaceColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  color: context.currentTextSecondary,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "No Image",
                                  style: TextStyle(
                                    color: context.currentTextSecondary,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                                backgroundColor: context.error,
                                child: Text(
                                  bookingCount.toString(),
                                  style: TextStyle(
                                    color: context.currentButtonPrimaryText,
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
                                    color: context.primary,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: context.currentTextSecondary,
                                    ),
                                    onPressed: () => Get.toNamed(
                                      Routes.editApartment,
                                      arguments: apartment,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: context.error,
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
                                color: context.currentTextSecondary,
                              ),
                              Text(
                                "${attr.location.city}, ${attr.location.governorate}",
                                style: TextStyle(
                                  color: context.currentTextSecondary,
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
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16.r),
        ),
        backgroundColor: context.currentButtonPrimary,
        elevation: 5,
        onPressed: () => Get.toNamed(Routes.createApartment),
        child: Icon(
          Icons.add_home_outlined,
          size: 30.sp,
          color: context.currentButtonPrimaryText,
        ),
      ),
    );
  }
}
