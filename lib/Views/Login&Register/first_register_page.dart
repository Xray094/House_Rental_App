import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Components/custom_text_field.dart';
import 'package:house_rental_app/core/controllers/register_controller.dart';
import 'package:house_rental_app/routes/app_routes.dart';

class FirstRegisterPage extends StatelessWidget {
  const FirstRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    const Color primaryBlue = Color(0xFF1E88E5);

    Widget roleCard(String role, IconData icon, String label) {
      return Obx(() {
        final bool isSelected = controller.selectedRole.value == role;
        return InkWell(
          onTap: () => controller.selectedRole.value = role,
          child: Container(
            height: 120.h,
            width: 140.w,
            decoration: BoxDecoration(
              color: isSelected ? primaryBlue.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: isSelected ? primaryBlue : Colors.grey.shade300,
                width: 2.w,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40.w,
                  color: isSelected ? primaryBlue : Colors.grey.shade600,
                ),
                SizedBox(height: 5.h),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? primaryBlue : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Create Account",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: 0.5,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(primaryBlue),
              minHeight: 5.h,
            ),
            Text(
              "1/2",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
            Image.asset("assets/images/imageForFirstRegisterPage.png"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                roleCard('tenant', Icons.person_outline, "Tenant"),
                roleCard('landlord', Icons.home_outlined, "Landlord"),
              ],
            ),
            SizedBox(height: 40.h),
            CustomTextField(
              name: 'Phone Number',
              hint: 'Ex: 9xx xxx xxx',
              prefixIcon: Icons.phone_android,
              inputType: TextInputType.phone,
              controller: controller.mobileController,
            ),
            SizedBox(height: 20.h),
            CustomTextField(
              name: 'Password',
              hint: 'Enter your password',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              controller: controller.passwordController,
              inputType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () {
                if (controller.selectedRole.value == null ||
                    controller.mobileController.text.isEmpty ||
                    controller.passwordController.text.isEmpty) {
                  Get.snackbar(
                    "Error",
                    "Please select a role and fill in credentials.",
                  );
                  return;
                }
                Get.toNamed(
                  Routes.secondRegister,
                  arguments: {
                    'role': controller.selectedRole.value,
                    'mobile': controller.mobileController.text,
                    'password': controller.passwordController.text,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
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
          ],
        ),
      ),
    );
  }
}
