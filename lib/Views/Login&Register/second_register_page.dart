import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:house_rental_app/Components/custom_text_field.dart';
import 'package:house_rental_app/core/controllers/register_controller.dart';

class SecondRegisterPage extends StatelessWidget {
  final String role;
  final String mobile;
  final String password;

  const SecondRegisterPage({
    super.key,
    required this.role,
    required this.mobile,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Personal Information",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: 1,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF1E88E5),
              ),
              minHeight: 5.h,
            ),
            SizedBox(height: 10.h),
            Text(
              "2/2",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
            SizedBox(height: 10.h),
            Center(
              child: InkWell(
                onTap: () => controller.pickImage(true),
                child: Obx(
                  () => Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1E88E5).withOpacity(0.1),
                      border: Border.all(
                        color: const Color(0xFF1E88E5),
                        width: 2.w,
                      ),
                    ),
                    child: controller.profileImage.value != null
                        ? ClipOval(
                            child: Image.file(
                              controller.profileImage.value!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.camera_alt_outlined,
                            size: 40.w,
                            color: const Color(0xFF1E88E5),
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: Obx(
                () => Text(
                  controller.profileImage.value != null
                      ? "Photo Selected"
                      : "Add Profile Photo",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),

            CustomTextField(
              name: 'First Name',
              hint: 'First Name',
              prefixIcon: Icons.person_outline,
              inputType: TextInputType.text,
              controller: controller.firstNameController,
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              name: 'Last Name',
              hint: 'Last Name',
              prefixIcon: Icons.contact_page_outlined,
              inputType: TextInputType.text,
              controller: controller.lastNameController,
            ),
            SizedBox(height: 10.h),

            Text(
              "Birth Date",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
            ),
            Obx(
              () => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.calendar_today,
                  color: const Color(0xFF1E88E5),
                  size: 24.w,
                ),
                title: Text(
                  controller.selectedDate.value == null
                      ? "Select Birth Date"
                      : DateFormat(
                          'yyyy-MM-dd',
                        ).format(controller.selectedDate.value!),
                  style: TextStyle(fontSize: 16.sp),
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    context: context,
                  );
                  if (picked != null) controller.selectedDate.value = picked;
                },
              ),
            ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () => controller.pickImage(false),
              child: Obx(
                () => Container(
                  height: 100.h,
                  width: double.infinity.w,
                  color: controller.idImage.value != null
                      ? const Color(0xFF1E88E5).withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 40.w,
                        color: const Color(0xFF1E88E5),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        controller.idImage.value != null
                            ? "ID Photo Selected"
                            : "Upload ID Photo",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF1E88E5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.registerUser(
                        role: role,
                        mobile: mobile,
                        password: password,
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  minimumSize: Size(double.infinity, 55.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Next",
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
