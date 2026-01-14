import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/core/controllers/edit_apartment_controller.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';

class EditApartment extends StatelessWidget {
  final ApartmentModel apartment;
  const EditApartment({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditApartmentController());
    final formKey = GlobalKey<FormState>();

    controller.loadApartmentData(apartment);

    return Scaffold(
      backgroundColor: context.currentBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Edit Apartment",
          style: TextStyle(color: context.currentAppBarTitleColor),
        ),
        centerTitle: true,
        backgroundColor: context.currentAppBarBackground,
        elevation: 0,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSectionTitle("Basic Details", context),
                      buildField(
                        controller.titleCtrl,
                        "Title",
                        Icons.title,
                        context,
                      ),
                      buildField(
                        controller.descCtrl,
                        "Description",
                        Icons.description,
                        context,
                        maxLines: 3,
                      ),
                      buildField(
                        controller.priceCtrl,
                        "Price per Night",
                        Icons.attach_money,
                        context,
                        isNum: true,
                      ),

                      const SizedBox(height: 16),
                      buildSectionTitle("Location", context),
                      buildField(
                        controller.govCtrl,
                        "Governorate",
                        Icons.map,
                        context,
                      ),
                      buildField(
                        controller.cityCtrl,
                        "City",
                        Icons.location_city,
                        context,
                      ),
                      buildField(
                        controller.addressCtrl,
                        "Exact Address",
                        Icons.home,
                        context,
                      ),

                      const SizedBox(height: 16),
                      buildSectionTitle("Specifications", context),
                      Row(
                        children: [
                          Expanded(
                            child: buildField(
                              controller.areaCtrl,
                              "Area (m²)",
                              Icons.square_foot,
                              context,
                              isNum: true,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: buildField(
                              controller.roomsCtrl,
                              "Rooms",
                              Icons.bed,
                              context,
                              isNum: true,
                            ),
                          ),
                        ],
                      ),
                      buildField(
                        controller.floorCtrl,
                        "Floor",
                        Icons.layers,
                        context,
                        isNum: true,
                      ),
                      Obx(
                        () => CheckboxListTile(
                          title: const Text("Has Balcony"),
                          value: controller.hasBalcony.value,
                          activeColor: context.primary,
                          onChanged: controller.toggleBalcony,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),

                      const SizedBox(height: 16),
                      buildSectionTitle("Features", context),
                      Obx(
                        () => Wrap(
                          spacing: 8.w,
                          runSpacing: 0,
                          children: controller.availableFeatures.map((feature) {
                            final isSelected = controller.selectedFeatures
                                .contains(feature);
                            return FilterChip(
                              label: Text(feature),
                              selected: isSelected,
                              selectedColor: context.primary.withOpacity(0.2),
                              checkmarkColor: context.primary,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? context.primary
                                    : context.currentTextSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              onSelected: (bool value) =>
                                  controller.toggleFeature(feature),
                              backgroundColor: context.currentInputFillColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                                side: BorderSide(
                                  color: isSelected
                                      ? context.primary
                                      : Colors.transparent,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildSectionTitle("Gallery", context),
                      buildImagePicker(controller, context),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.currentButtonPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          onPressed: controller.isUpdating.value
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    controller.updateApartment();
                                  }
                                },
                          child: controller.isUpdating.value
                              ? CircularProgressIndicator(
                                  color: context.currentButtonPrimaryText,
                                )
                              : Text(
                                  "Update Apartment",
                                  style: TextStyle(
                                    color: context.currentButtonPrimaryText,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: context.primary,
        ),
      ),
    );
  }

  Widget buildField(
    TextEditingController ctrl,
    String label,
    IconData icon,
    BuildContext context, {
    bool isNum = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        inputFormatters: isNum
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : null,
        style: TextStyle(color: context.currentTextPrimary),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: context.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: context.currentDividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: context.primary),
          ),
        ),
        validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
      ),
    );
  }

  Widget buildImagePicker(
    EditApartmentController controller,
    BuildContext context,
  ) {
    return Column(
      children: [
        Obx(
          () => controller.existingImageUrls.isEmpty
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Images:",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: context.currentTextSecondary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      height: 100.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.existingImageUrls.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10.w),
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      controller.existingImageUrls[index],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 15,
                                child: GestureDetector(
                                  onTap: () =>
                                      controller.removeExistingImage(index),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: context.error,
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: context.currentButtonPrimaryText,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
        ),
        InkWell(
          onTap: controller.pickImages,
          child: Container(
            width: double.infinity,
            height: 100.h,
            decoration: BoxDecoration(
              border: Border.all(color: context.currentDividerColor),
              borderRadius: BorderRadius.circular(10.r),
              color: context.currentSurfaceColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo,
                  color: context.currentTextSecondary,
                  size: 40,
                ),
                Text(
                  "Click to add new photos",
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => controller.gallery.isEmpty
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "New Images:",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.gallery.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10.w),
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  image: DecorationImage(
                                    image: FileImage(controller.gallery[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 15,
                                child: GestureDetector(
                                  onTap: () => controller.removeNewImage(index),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: context.error,
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: context.currentButtonPrimaryText,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
