import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/core/colors/color.dart';
import 'package:house_rental_app/core/controllers/favorites_controller.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:house_rental_app/routes/app_routes.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController controller = Get.put(FavoritesController());

    return Scaffold(
      backgroundColor: context.currentBackgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: context.currentButtonPrimary,
            ),
          );
        }

        if (controller.favoriteApartments.isEmpty) {
          return buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadFavorites(),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            itemCount: controller.favoriteApartments.length,
            itemBuilder: (context, index) {
              final ApartmentModel apartment =
                  controller.favoriteApartments[index];
              final attr = apartment.attributes;
              return InkWell(
                onTap: () {
                  Get.toNamed(Routes.apartmentDetails, arguments: apartment);
                },
                child: Card(
                  margin: EdgeInsets.only(bottom: 20.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: attr.galleryUrls.isNotEmpty
                            ? attr.galleryUrls.first
                            : "",
                        height: 160.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Container(
                              height: 160.h,
                              width: double.infinity,
                              color: context.currentCardColor,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                ),
                              ),
                            ),
                        memCacheHeight: 400,
                        maxWidthDiskCache: 800,
                        errorWidget: (context, url, error) => Container(
                          color: context.currentCardColor,
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
                      Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    color: context.currentTextSecondary,
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
                                    color: context.currentTextPrimary,
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
                                    color: context.currentTextPrimary,
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
    );
  }

  Widget buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80.sp,
              color: context.currentTextSecondary,
            ),
            SizedBox(height: 24.h),
            Text(
              'No Favorite Apartments',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: context.currentTextPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Start exploring and tap the heart icon to save your favorite apartments!',
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
