import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:house_rental_app/Models/review_model.dart';
import 'package:house_rental_app/core/controllers/apartment_controller.dart';
import 'package:house_rental_app/core/controllers/auth_controller.dart';
import 'package:house_rental_app/core/controllers/favorites_controller.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';

class ApartmentDetailsPage extends StatelessWidget {
  const ApartmentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ApartmentController ctrl = Get.find<ApartmentController>();
    final AuthController authController = Get.find<AuthController>();
    final FavoritesController favoritesController = Get.put(
      FavoritesController(),
    );
    final arg = Get.arguments;
    if (arg is String) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ctrl.loadDetails(arg);
      });
    } else if (arg is ApartmentModel) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final current = ctrl.apartment.value;
        if (current != null && (current.reviews.isEmpty)) {
          ctrl.loadDetails(current.id);
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final current = ctrl.apartment.value;
        if (current != null && current.reviews.isEmpty) {
          ctrl.loadDetails(current.id);
        }
      });
    }

    return Obx(() {
      if (ctrl.isLoading.value || ctrl.apartment.value == null) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Loading...'),
            backgroundColor: context.primary,
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      final apt = ctrl.apartment.value!;
      final attr = apt.attributes;

      return Scaffold(
        appBar: AppBar(
          title: Text(attr.title),
          backgroundColor: context.primary,
          actions: [
            if (authController.isTenant)
              Obx(
                () => IconButton(
                  icon: Icon(
                    size: 24.h,
                    ctrl.isFavorite.value
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: context.error,
                  ),
                  onPressed: () async {
                    final isNowFavorite = await favoritesController
                        .toggleFavorite(apt.id);
                    ctrl.isFavorite.value = isNowFavorite;

                    // Show snackbar feedback
                    Get.snackbar(
                      isNowFavorite
                          ? 'Added to Favorites'
                          : 'Removed from Favorites',
                      isNowFavorite
                          ? 'Apartment saved to your favorites'
                          : 'Apartment removed from favorites',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: isNowFavorite
                          ? context.primary
                          : context.error,
                      colorText: context.currentButtonPrimaryText,
                    );
                  },
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildGallerySlider(context, attr.galleryUrls),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attr.title,
                      style: TextStyle(
                        color: context.currentTextPrimary,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      attr.formattedPrice,
                      style: TextStyle(
                        color: context.currentTextPrimary,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16.h,
                          color: context.primary,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            '${attr.location.city}, ${attr.location.governorate}',
                            style: TextStyle(
                              color: context.currentTextPrimary,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              _buildSpecifications(context, apt),
              const Divider(),
              buildSectionTitle(context, 'Description'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  attr.description,
                  style: TextStyle(
                    color: context.currentTextPrimary,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Divider(),
              buildSectionTitle(context, 'Apartment Features'),
              buildFeaturesGrid(context, attr.features),
              const Divider(),
              buildSectionTitle(context, 'Full Address'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  '${attr.location.address}\n${attr.location.city}, ${attr.location.governorate}',
                  style: TextStyle(
                    color: context.currentTextPrimary,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (authController.isTenant) ...[
                const Divider(),
                buildSectionTitle(context, 'Select Rental Dates'),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      Obx(
                        () => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.calendar_today,
                            color: context.primary,
                            size: 24.w,
                          ),
                          title: Text(
                            ctrl.startDate.value == null
                                ? "Select Start Date"
                                : DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(ctrl.startDate.value!),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: context.currentTextPrimary,
                            ),
                          ),
                          subtitle: Text(
                            "Check-in Date",
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (picked != null) ctrl.startDate.value = picked;
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      Obx(
                        () => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.event_available,
                            color: context.primary,
                            size: 24.w,
                          ),
                          title: Text(
                            ctrl.endDate.value == null
                                ? "Select End Date"
                                : DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(ctrl.endDate.value!),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: context.currentTextPrimary,
                            ),
                          ),
                          subtitle: Text(
                            "Check-out Date",
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  ctrl.startDate.value?.add(
                                    const Duration(days: 1),
                                  ) ??
                                  DateTime.now().add(const Duration(days: 1)),
                              firstDate: ctrl.startDate.value ?? DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (picked != null) ctrl.endDate.value = picked;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
              const Divider(),
              buildSectionTitle(context, 'Reviews (${apt.reviews.length})'),
              _buildReviewsList(apt.reviews),
            ],
          ),
        ),
        bottomNavigationBar: Obx(() {
          if (!authController.isTenant) return const SizedBox.shrink();

          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: context.currentSurfaceColor,
              boxShadow: [
                BoxShadow(
                  color: context.currentDividerColor.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),

            child: ElevatedButton.icon(
              onPressed: ctrl.isBooking.value
                  ? null
                  : () async {
                      showDialog(
                        context: context,

                        barrierDismissible: false,

                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      final String? errorMessage = await ctrl.book();

                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }

                      if (errorMessage == null) {
                        Get.snackbar(
                          'Success',

                          'Your request was sent successfully.',

                          backgroundColor: context.primary,

                          colorText: context.currentButtonPrimaryText,

                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },

              icon: const Icon(Icons.book_rounded),

              label: Text(ctrl.isBooking.value ? 'Booking...' : 'Book Now'),

              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50.h),

                backgroundColor: context.currentButtonPrimary,

                foregroundColor: context.currentButtonPrimaryText,
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildReviewsList(List<ReviewModel> reviews) {
    if (reviews.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: const Text("No reviews yet for this apartment."),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: reviews.length,
      separatorBuilder: (context, index) => Divider(height: 24.h),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: NetworkImage(review.reviewerAvatar),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.reviewerName,
                        style: TextStyle(
                          color: context.currentTextPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            Icons.star,
                            size: 14.sp,
                            color: starIndex < review.rating
                                ? Colors.amber
                                : context.currentDividerColor,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Text(
                  review.createdAt,
                  style: TextStyle(
                    color: context.currentTextSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 14.sp,
                color: context.currentTextPrimary,
                height: 1.4,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSpecifications(BuildContext context, ApartmentModel apartment) {
    final specs = apartment.attributes.specs;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          specItem(context, Icons.bed, '${specs.rooms}', 'Rooms'),
          specItem(context, Icons.square_foot, '${specs.area} m²', 'Area'),
          specItem(context, Icons.layers, '${specs.floor}', 'Floor'),
          specItem(
            context,
            specs.hasBalcony ? Icons.balcony : Icons.window,
            specs.hasBalcony ? 'One' : 'No',
            'Balcony',
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySlider(BuildContext context, List<String> galleryUrls) {
    if (galleryUrls.isEmpty) {
      return Container(
        height: 250,
        color: context.currentSurfaceColor,
        alignment: Alignment.center,
        child: Text(
          'No Images Available',
          style: TextStyle(color: context.currentTextSecondary),
        ),
      );
    }
    return SizedBox(
      height: 250.0,
      child: PageView.builder(
        itemCount: galleryUrls.length,
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl: galleryUrls[index],
            height: 250.h,
            width: double.infinity,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Container(
                  height: 250.h,
                  width: double.infinity,
                  color: context.currentSurfaceColor,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      color: context.primary,
                    ),
                  ),
                ),
            memCacheHeight: 500,
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
          );
        },
      ),
    );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          color: context.primary,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget specItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, size: 28.0, color: context.primary),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: TextStyle(
            color: context.currentTextPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: context.currentTextSecondary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget buildFeaturesGrid(BuildContext context, List<String> features) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: features
            .map(
              (feature) => Chip(
                label: Text(feature),
                avatar: Icon(
                  Icons.check_circle,
                  size: 18,
                  color: context.primary,
                ),
                backgroundColor: context.primary.withOpacity(0.1),
                labelStyle: TextStyle(color: context.currentTextPrimary),
              ),
            )
            .toList(),
      ),
    );
  }
}
