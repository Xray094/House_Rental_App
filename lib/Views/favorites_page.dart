import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Views/apartment_detail_page.dart';
import 'package:house_rental_app/core/controllers/favorites_controller.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          color: context.currentButtonPrimary,
          onRefresh: controller.loadFavorites,
          child: ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.favoriteApartments.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final apartment = controller.favoriteApartments[index];
              return _buildFavoriteCard(context, apartment, controller);
            },
          ),
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

  Widget _buildFavoriteCard(
    BuildContext context,
    ApartmentModel apartment,
    FavoritesController controller,
  ) {
    final attr = apartment.attributes;

    return Card(
      elevation: 2,
      color: context.currentCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: () =>
            Get.to(() => const ApartmentDetailsPage(), arguments: apartment.id),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: SizedBox(
                  height: 160.h,
                  width: double.infinity,
                  child: attr.galleryUrls.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: attr.galleryUrls.first,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Container(
                                color: context.currentCardColor,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                    color: context.currentButtonPrimary,
                                  ),
                                ),
                              ),
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
                                  'No Image',
                                  style: TextStyle(
                                    color: context.currentTextSecondary,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          color: context.currentCardColor,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.apartment,
                                  color: context.currentTextSecondary,
                                  size: 40,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'No Image',
                                  style: TextStyle(
                                    color: context.currentTextSecondary,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 12.h),
              // Content section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          attr.title,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: context.currentTextPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          attr.formattedPrice,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: context.currentButtonPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16.sp,
                              color: context.currentTextSecondary,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                '${attr.location.city}, ${attr.location.governorate}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: context.currentTextSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            _buildSpecChip(
                              context,
                              Icons.bed,
                              '${attr.specs.rooms} rooms',
                            ),
                            SizedBox(width: 8.w),
                            _buildSpecChip(
                              context,
                              Icons.square_foot,
                              '${attr.specs.area} m²',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Favorite button
                  Column(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await controller.removeFromFavorites(apartment.id);
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: context.error,
                          size: 28.sp,
                        ),
                        tooltip: 'Remove from favorites',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: context.currentButtonPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: context.currentButtonPrimary),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: context.currentButtonPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
