import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/core/colors/color.dart';
import 'package:house_rental_app/core/controllers/home_controller.dart';
import 'package:house_rental_app/routes/app_routes.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController ctrl = Get.find<HomeController>();

  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController minRoomsController = TextEditingController();
  final TextEditingController minAreaController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 2000),
            height: ctrl.isFiltersVisible.value ? null : 0,
            child: Container(
              padding: EdgeInsets.all(10.w),
              color: context.currentCardColor,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Governorate',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                              ),
                            ),
                            value: ctrl.selectedGovernorate.value,
                            items: _getGovernorates().map((gov) {
                              return DropdownMenuItem(
                                value: gov,
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  gov,
                                  style: TextStyle(
                                    color: context.currentTextPrimary,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: ctrl.setGovernorate,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Obx(
                          () => DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'City',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                              ),
                            ),
                            value: ctrl.selectedCity.value,
                            items: _getCities().map((city) {
                              return DropdownMenuItem(
                                value: city,
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  city,
                                  style: TextStyle(
                                    color: context.currentTextPrimary,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: ctrl.setCity,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: minPriceController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(color: context.currentTextPrimary),
                          decoration: InputDecoration(
                            labelText: 'Min Price',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            ctrl.setMinPrice(double.tryParse(value));
                          },
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextFormField(
                          controller: maxPriceController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(color: context.currentTextPrimary),
                          decoration: InputDecoration(
                            labelText: 'Max Price',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            ctrl.setMaxPrice(double.tryParse(value));
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: minRoomsController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(color: context.currentTextPrimary),
                          decoration: InputDecoration(
                            labelText: 'Min Rooms',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            ctrl.setMinRooms(int.tryParse(value));
                          },
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextFormField(
                          controller: minAreaController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(color: context.currentTextPrimary),
                          decoration: InputDecoration(
                            labelText: 'Min Area (m²)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            ctrl.setMinArea(int.tryParse(value));
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Divider(
                      color: context.currentDividerColor,
                      thickness: 1,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ctrl.clearFilters();
                      minPriceController.clear();
                      maxPriceController.clear();
                      minRoomsController.clear();
                      minAreaController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Clear Filters'),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            final filteredList = ctrl.filteredApartments;
            if (ctrl.isLoading.value && ctrl.apartments.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (ctrl.error.value != null && ctrl.apartments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error loading apartments: ${ctrl.error.value}'),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => ctrl.loadApartments(),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (filteredList.isEmpty && ctrl.apartments.isEmpty) {
              return Center(
                child: Text(
                  'No apartments found.',
                  style: TextStyle(color: context.currentTextPrimary),
                ),
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                // Trigger load more when near bottom
                if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 200 &&
                    !ctrl.isLoadingMore.value &&
                    ctrl.hasMorePages.value &&
                    filteredList.isNotEmpty) {
                  ctrl.loadMoreApartments();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () => ctrl.loadApartments(),
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 10.h,
                  ),
                  itemCount:
                      filteredList.length + 1, // +1 for loading indicator
                  itemBuilder: (context, index) {
                    // Show loading indicator at the end
                    if (index >= filteredList.length) {
                      return _buildLoadingIndicator();
                    }

                    final ApartmentModel apartment = filteredList[index];
                    final attr = apartment.attributes;
                    return InkWell(
                      onTap: () {
                        Get.toNamed(
                          Routes.apartmentDetails,
                          arguments: apartment,
                        );
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
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Obx(() {
      if (ctrl.isLoadingMore.value) {
        return Container(
          padding: EdgeInsets.all(16.h),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 10.w),
              Text(
                'Loading more apartments...',
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
          ),
        );
      }
      if (!ctrl.hasMorePages.value && ctrl.apartments.isNotEmpty) {
        return Container(
          padding: EdgeInsets.all(16.h),
          alignment: Alignment.center,
          child: Text(
            'No more apartments to load',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        );
      }
      return SizedBox.shrink();
    });
  }

  List<String> _getGovernorates() {
    // if (ctrl.availableGovernorates.isNotEmpty) {
    return ctrl.availableGovernorates;
    // }
    // // Fallback: extract from loaded apartments if filter options not loaded yet
    // return ctrl.apartments
    //     .map((a) => a.attributes.location.governorate)
    //     .where((g) => g.isNotEmpty)
    //     .toSet()
    //     .toList()
    //   ..sort();
  }

  List<String> _getCities() {
    // if (ctrl.availableCities.isNotEmpty) {
    return ctrl.availableCities;
    // }
    // // Fallback: extract from loaded apartments if filter options not loaded yet
    // return ctrl.apartments
    //     .map((a) => a.attributes.location.city)
    //     .where((c) => c.isNotEmpty)
    //     .toSet()
    //     .toList()
    //   ..sort();
  }
}
