import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:house_rental_app/Components/custom_text_field.dart';
import 'package:house_rental_app/Models/register_model.dart';
import 'package:house_rental_app/Services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class SecondRegisterPage extends StatefulWidget {
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
  State<SecondRegisterPage> createState() => _SecondRegisterPageState();
}

class _SecondRegisterPageState extends State<SecondRegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  DateTime? selectedDate;
  File? profileImage;
  File? idImage;
  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
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
                onTap: () async {
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() {
                      profileImage = File(image.path);
                    });
                  }
                },
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1E88E5).withOpacity(0.1),
                    border: Border.all(color: Color(0xFF1E88E5), width: 2.w),
                  ),
                  child: profileImage != null
                      ? ClipOval(
                          child: Image.file(profileImage!, fit: BoxFit.cover),
                        )
                      : Icon(
                          Icons.camera_alt_outlined,
                          size: 40.w,
                          color: Color(0xFF1E88E5),
                        ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: Text(
                profileImage != null ? "Photo Selected" : "Add Profile Photo",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
              ),
            ),
            SizedBox(height: 40.h),
            CustomTextField(
              name: 'First Name',
              hint: 'First Name',
              prefixIcon: Icons.person_outline,
              inputType: TextInputType.text,
              controller: firstNameController,
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              name: 'Last Name',
              hint: 'Last Name',
              prefixIcon: Icons.contact_page_outlined,
              inputType: TextInputType.text,
              controller: lastNameController,
            ),
            SizedBox(height: 10.h),
            Text(
              "Birth Date",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.calendar_today,
                color: Color(0xFF1E88E5),
                size: 24.w,
              ),
              title: Text(
                selectedDate == null
                    ? "Select Birth Date"
                    : DateFormat('yyyy-MM-dd').format(selectedDate!),
                style: TextStyle(fontSize: 16.sp),
              ),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  context: context,
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
            ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () async {
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  setState(() {
                    idImage = File(image.path);
                  });
                }
              },
              child: Container(
                height: 100.h,
                width: double.infinity.w,
                color: idImage != null
                    ? Color(0xFF1E88E5).withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 40.w,
                      color: Color(0xFF1E88E5),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      idImage != null ? "ID Photo Selected" : "Upload ID Photo",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF1E88E5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            ElevatedButton(
              onPressed: () async {
                if (firstNameController.text.isEmpty ||
                    lastNameController.text.isEmpty ||
                    selectedDate == null ||
                    profileImage == null ||
                    idImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "All personal fields and photos are required!",
                      ),
                    ),
                  );
                  return;
                }
                Get.dialog(
                  const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );
                bool success = await Get.find<AuthService>().register(
                  RegisterModule(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    mobile: widget.mobile,
                    password: widget.password,
                    birthDate: selectedDate!,
                    profileImage: profileImage!,
                    idImage: idImage!,
                    role: widget.role,
                  ),
                );

                Get.back();

                if (success) {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  Get.snackbar(
                    'Success',
                    'Registration successful! Wait for Admin approval.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'Registration failed. Check your input.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E88E5),
                minimumSize: Size(double.infinity, 55.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                "Next",
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
