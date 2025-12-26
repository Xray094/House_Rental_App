import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:house_rental_app/Components/custom_text_field.dart';
import 'package:house_rental_app/core/controllers/register_controller.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';

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
        backgroundColor: context.currentAppBarBackground,
        title: Text(
          "Personal Information",
          style: TextStyle(color: context.currentAppBarTitleColor),
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
              backgroundColor: context.currentDividerColor,
              valueColor: AlwaysStoppedAnimation<Color>(context.primary),
              minHeight: 5.h,
            ),
            SizedBox(height: 10.h),
            Text(
              "2/2",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: context.currentTextSecondary,
              ),
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
                      color: context.primary.withOpacity(0.1),
                      border: Border.all(color: context.primary, width: 2.w),
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
                            color: context.primary,
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
                    color: context.currentTextSecondary,
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
                  color: context.primary,
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
                      ? context.primary.withOpacity(0.1)
                      : context.currentInputFillColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 40.w,
                        color: context.primary,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        controller.idImage.value != null
                            ? "ID Photo Selected"
                            : "Upload ID Photo",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: context.primary,
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
                  backgroundColor: context.currentButtonPrimary,
                  minimumSize: Size(double.infinity, 55.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: controller.isLoading.value
                    ? CircularProgressIndicator(
                        color: context.currentButtonPrimaryText,
                      )
                    : Text(
                        "Next",
                        style: TextStyle(
                          color: context.currentButtonPrimaryText,
                          fontSize: 16.sp,
                        ),
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
