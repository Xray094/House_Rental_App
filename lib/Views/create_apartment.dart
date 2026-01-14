import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Components/custom_text_field.dart';
import 'package:house_rental_app/core/controllers/create_apartment_controller.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';

final FilteringTextInputFormatter lettersOnlyFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'));

class CreateApartment extends StatelessWidget {
  const CreateApartment({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateApartmentController());

    return Scaffold(
      backgroundColor: context.currentBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Add New Apartment",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionTitle("Basic Details", context),
                    Obx(
                      () => CustomTextField(
                        name: 'Title',
                        hint: 'Enter apartment title',
                        prefixIcon: Icons.title,
                        controller: controller.titleCtrl,
                        inputType: TextInputType.text,
                        errorText: controller.titleError.value.isEmpty
                            ? null
                            : controller.titleError.value,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Obx(
                      () => CustomTextField(
                        name: 'Description',
                        hint: 'Enter description (min 20 characters)',
                        prefixIcon: Icons.description,
                        controller: controller.descCtrl,
                        inputType: TextInputType.multiline,
                        errorText: controller.descError.value.isEmpty
                            ? null
                            : controller.descError.value,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Obx(
                      () => CustomTextField(
                        name: 'Price per Night',
                        hint: 'Between 1 and 10000',
                        prefixIcon: Icons.attach_money,
                        controller: controller.priceCtrl,
                        inputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        errorText: controller.priceError.value.isEmpty
                            ? null
                            : controller.priceError.value,
                      ),
                    ),

                    SizedBox(height: 16.h),
                    buildSectionTitle("Location", context),
                    Obx(
                      () => CustomTextField(
                        name: 'Governorate',
                        hint: 'Enter governorate',
                        prefixIcon: Icons.map,
                        controller: controller.govCtrl,
                        inputType: TextInputType.text,
                        inputFormatters: [lettersOnlyFormatter],
                        errorText: controller.govError.value.isEmpty
                            ? null
                            : controller.govError.value,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Obx(
                      () => CustomTextField(
                        name: 'City',
                        hint: 'Enter city',
                        prefixIcon: Icons.location_city,
                        controller: controller.cityCtrl,
                        inputType: TextInputType.text,
                        inputFormatters: [lettersOnlyFormatter],
                        errorText: controller.cityError.value.isEmpty
                            ? null
                            : controller.cityError.value,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Obx(
                      () => CustomTextField(
                        name: 'Exact Address',
                        hint: 'Enter full address',
                        prefixIcon: Icons.home,
                        controller: controller.addressCtrl,
                        inputType: TextInputType.text,
                        errorText: controller.addressError.value.isEmpty
                            ? null
                            : controller.addressError.value,
                      ),
                    ),

                    SizedBox(height: 16.h),
                    buildSectionTitle("Specifications", context),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => CustomTextField(
                              name: 'Area (m²)',
                              hint: 'Max 10000',
                              prefixIcon: Icons.square_foot,
                              controller: controller.areaCtrl,
                              inputType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              errorText: controller.areaError.value.isEmpty
                                  ? null
                                  : controller.areaError.value,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Obx(
                            () => CustomTextField(
                              name: 'Rooms',
                              hint: '1-100',
                              prefixIcon: Icons.bed,
                              controller: controller.roomsCtrl,
                              inputType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              errorText: controller.roomsError.value.isEmpty
                                  ? null
                                  : controller.roomsError.value,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Obx(
                      () => CustomTextField(
                        name: 'Floor',
                        hint: '0-200',
                        prefixIcon: Icons.layers,
                        controller: controller.floorCtrl,
                        inputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        errorText: controller.floorError.value.isEmpty
                            ? null
                            : controller.floorError.value,
                      ),
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

                    SizedBox(height: 16.h),
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
                    Obx(
                      () => controller.featuresError.value.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: 5.h, left: 12.w),
                              child: Text(
                                controller.featuresError.value,
                                style: TextStyle(
                                  color: context.error,
                                  fontSize: 12.sp,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    SizedBox(height: 16.h),
                    buildSectionTitle("Gallery", context),
                    buildImagePicker(controller, context),
                    Obx(
                      () => controller.imagesError.value.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: 5.h, left: 12.w),
                              child: Text(
                                controller.imagesError.value,
                                style: TextStyle(
                                  color: context.error,
                                  fontSize: 12.sp,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    SizedBox(height: 32.h),
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
                        onPressed: () {
                          controller.validateFields();
                        },
                        child: Text(
                          "Submit Apartment",
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

  Widget buildImagePicker(
    CreateApartmentController controller,
    BuildContext context,
  ) {
    return Column(
      children: [
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
                  "Click to add photos",
                  style: TextStyle(
                    color: context.currentTextSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => controller.gallery.isEmpty
              ? const SizedBox()
              : SizedBox(
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
                              onTap: () => controller.removeImage(index),
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
        ),
      ],
    );
  }
}
