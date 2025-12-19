import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:house_rental_app/core/colors/color.dart';
import 'package:house_rental_app/core/controllers/apartment_controller.dart';

class ApartmentDetailsPage extends StatelessWidget {
  final ApartmentModel apartment;

  const ApartmentDetailsPage({Key? key, required this.apartment})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApartmentController ctrl = Get.find<ApartmentController>();
    final apt = ctrl.apartment.value!;
    final attr = apt.attributes;
    return Scaffold(
      appBar: AppBar(
        title: Text(attr.title),
        backgroundColor: primaryBlue,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                ctrl.isFavorite.value ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: ctrl.toggleFavorite,
            ),
          ),
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
            _buildSpecifications(context, apartment),
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
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
        child: Obx(() {
          final ApartmentController ctrl = Get.find<ApartmentController>();
          return ElevatedButton.icon(
            onPressed: ctrl.isBooking.value
                ? null
                : () async {
                    Get.dialog(
                      const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );
                    final success = await ctrl.book();
                    Get.back();
                    if (success) {
                      Get.snackbar(
                        'Booked',
                        'Your booking request was sent.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'Booking failed',
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
          );
        }),
      ),
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
