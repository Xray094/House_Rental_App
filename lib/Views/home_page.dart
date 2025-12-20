import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/core/controllers/home_controller.dart';
import 'package:house_rental_app/routes/app_routes.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final Color primaryBlue = const Color(0xFF1E88E5);
  final HomeController ctrl = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (ctrl.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (ctrl.error.value != null) {
              return Center(
                child: Text('Error loading apartments: ${ctrl.error.value}'),
              );
            }
            if (ctrl.apartments.isEmpty) {
              return const Center(child: Text('No apartments found.'));
            }
            return RefreshIndicator(
              onRefresh: () => ctrl.loadApartments(),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                itemCount: ctrl.apartments.length,
                itemBuilder: (context, index) {
                  final ApartmentModel apartment = ctrl.apartments[index];
                  final attr = apartment.attributes;
                  return InkWell(
                    onTap: () {
                      Get.toNamed(
                        Routes.apartmentDetails,
                        arguments: apartment,
                      );
                    },

                    child: Card(
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            attr.galleryUrls.isNotEmpty
                                ? attr.galleryUrls.first
                                : 'https://via.placeholder.com/160',
                            height: 160.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 160.h,
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        attr.title,
                                        style: TextStyle(
                                          color: primaryBlue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      attr.formattedPrice,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                        color: primaryBlue,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: primaryBlue,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '${attr.location.city}, ${attr.location.governorate}',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.king_bed_outlined,
                                      color: primaryBlue,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '${attr.specs.rooms} rooms',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 15.w),
                                    Icon(
                                      Icons.square_foot,
                                      color: primaryBlue,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '${attr.specs.area} m²',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
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
          }),
        ),
      ],
    );
  }
}
