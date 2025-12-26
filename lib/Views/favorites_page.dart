import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Views/apartment_detail_page.dart';
import 'package:house_rental_app/core/controllers/favorites_controller.dart';
import 'package:house_rental_app/core/colors/color.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController controller = Get.put(FavoritesController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryBlue));
        }

        if (controller.favoriteApartments.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: primaryBlue,
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80.sp, color: Colors.grey),
            SizedBox(height: 24.h),
            Text(
              'No Favorite Apartments',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Start exploring and tap the heart icon to save your favorite apartments!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
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
                                color: Colors.grey.shade100,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                    color: primaryBlue,
                                  ),
                                ),
                              ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'No Image',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.apartment,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'No Image',
                                  style: TextStyle(
                                    color: Colors.grey,
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
                            color: Colors.black87,
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
                            color: primaryBlue,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16.sp,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                '${attr.location.city}, ${attr.location.governorate}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
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
                              Icons.bed,
                              '${attr.specs.rooms} rooms',
                            ),
                            SizedBox(width: 8.w),
                            _buildSpecChip(
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
                          color: Colors.red,
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

  Widget _buildSpecChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: primaryBlue),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
