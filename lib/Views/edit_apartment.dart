import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/core/controllers/edit_apartment_controller.dart';

class EditApartment extends StatelessWidget {
  final ApartmentModel apartment;
  const EditApartment({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditApartmentController());
    final formKey = GlobalKey<FormState>();

    // Load apartment data when the widget initializes
    controller.loadApartmentData(apartment);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Apartment"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E88E5),
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
                      _buildSectionTitle("Basic Details"),
                      _buildField(controller.titleCtrl, "Title", Icons.title),
                      _buildField(
                        controller.descCtrl,
                        "Description",
                        Icons.description,
                        maxLines: 3,
                      ),
                      _buildField(
                        controller.priceCtrl,
                        "Price per Night",
                        Icons.attach_money,
                        isNum: true,
                      ),

                      const SizedBox(height: 16),
                      _buildSectionTitle("Location"),
                      _buildField(controller.govCtrl, "Governorate", Icons.map),
                      _buildField(
                        controller.cityCtrl,
                        "City",
                        Icons.location_city,
                      ),
                      _buildField(
                        controller.addressCtrl,
                        "Exact Address",
                        Icons.home,
                      ),

                      const SizedBox(height: 16),
                      _buildSectionTitle("Specifications"),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              controller.areaCtrl,
                              "Area (m²)",
                              Icons.square_foot,
                              isNum: true,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _buildField(
                              controller.roomsCtrl,
                              "Rooms",
                              Icons.bed,
                              isNum: true,
                            ),
                          ),
                        ],
                      ),
                      _buildField(
                        controller.floorCtrl,
                        "Floor",
                        Icons.layers,
                        isNum: true,
                      ),
                      Obx(
                        () => CheckboxListTile(
                          title: const Text("Has Balcony"),
                          value: controller.hasBalcony.value,
                          activeColor: const Color(0xFF1E88E5),
                          onChanged: controller.toggleBalcony,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),

                      const SizedBox(height: 16),
                      _buildSectionTitle("Features"),
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
                              selectedColor: const Color(
                                0xFF1E88E5,
                              ).withOpacity(0.2),
                              checkmarkColor: const Color(0xFF1E88E5),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF1E88E5)
                                    : Colors.black54,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              onSelected: (bool value) =>
                                  controller.toggleFeature(feature),
                              backgroundColor: Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                                side: BorderSide(
                                  color: isSelected
                                      ? const Color(0xFF1E88E5)
                                      : Colors.transparent,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSectionTitle("Gallery"),
                      _buildImagePicker(controller),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E88E5),
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
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Update Apartment",
                                  style: TextStyle(
                                    color: Colors.white,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1E88E5),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
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
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF1E88E5)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Color(0xFF1E88E5)),
          ),
        ),
        validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
      ),
    );
  }

  Widget _buildImagePicker(EditApartmentController controller) {
    return Column(
      children: [
        // Existing Images
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
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
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
                                  child: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
        ),
        // New Images Section
        InkWell(
          onTap: controller.pickImages,
          child: Container(
            width: double.infinity,
            height: 100.h,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.grey.shade50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
                Text(
                  "Click to add new photos",
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // New Images Preview
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
                                  child: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
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
