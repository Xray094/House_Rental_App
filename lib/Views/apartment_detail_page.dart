import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:house_rental_app/Models/review_model.dart';
import 'package:house_rental_app/core/colors/color.dart';
import 'package:house_rental_app/core/controllers/apartment_controller.dart';
import 'package:house_rental_app/core/controllers/auth_controller.dart';
import 'package:intl/intl.dart';

class ApartmentDetailsPage extends StatelessWidget {
  const ApartmentDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApartmentController ctrl = Get.find<ApartmentController>();
    final AuthController authController = Get.find<AuthController>();
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
            backgroundColor: primaryBlue,
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      final apt = ctrl.apartment.value!;
      final attr = apt.attributes;

      return Scaffold(
        appBar: AppBar(
          title: Text(attr.title),
          backgroundColor: primaryBlue,
          actions: [
            // Obx(
            //   () => IconButton(
            //     icon: Icon(
            //       ctrl.isFavorite.value ? Icons.favorite : Icons.favorite_border,
            //     ),
            //     onPressed: ctrl.toggleFavorite,
            //   ),
            // ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildGallerySlider(attr.galleryUrls),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attr.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      attr.formattedPrice,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16.h, color: primaryBlue),
                        SizedBox(width: 4.w),
                        Text(
                          '${attr.location.city}, ${attr.location.governorate}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
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
                    color: Colors.black,
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
                    color: Colors.black,
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
                            color: primaryBlue,
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
                              color: Colors.black87,
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
                            color: primaryBlue,
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
                              color: Colors.black87,
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
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
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

                          backgroundColor: Colors.green,

                          colorText: Colors.white,

                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },

              icon: const Icon(Icons.book_rounded),

              label: Text(ctrl.isBooking.value ? 'Booking...' : 'Book Now'),

              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50.h),

                backgroundColor: primaryBlue,

                foregroundColor: Colors.white,
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
                                : Colors.grey.shade300,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Text(
                  review.createdAt,
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
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

  Widget _buildGallerySlider(List<String> galleryUrls) {
    if (galleryUrls.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: const Text('No Images Available'),
      );
    }
    return SizedBox(
      height: 250.0,
      child: PageView.builder(
        itemCount: galleryUrls.length,
        itemBuilder: (context, index) {
          return Image.network(
            galleryUrls[index],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.image_not_supported)),
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
          color: primaryBlue,
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
        Icon(icon, size: 28.0, color: primaryBlue),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
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
                avatar: const Icon(Icons.check_circle, size: 18),
                backgroundColor: primaryBlue.withOpacity(0.1),
                labelStyle: const TextStyle(color: Colors.black),
              ),
            )
            .toList(),
      ),
    );
  }
}
