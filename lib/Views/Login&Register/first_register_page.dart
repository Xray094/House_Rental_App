import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Components/custom_text_field.dart';
import 'package:house_rental_app/core/controllers/register_controller.dart';
import 'package:house_rental_app/routes/app_routes.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';

class FirstRegisterPage extends StatelessWidget {
  const FirstRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

    Widget roleCard(String role, IconData icon, String label) {
      return Obx(() {
        final bool isSelected = controller.selectedRole.value == role;
        return InkWell(
          onTap: () => controller.selectedRole.value = role,
          child: Container(
            height: 120.h,
            width: 140.w,
            decoration: BoxDecoration(
              color: isSelected
                  ? context.primary.withOpacity(0.1)
                  : context.currentRoleCardBackground,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: isSelected
                    ? context.primary
                    : context.currentRoleCardBorder,
                width: 2.w,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40.w,
                  color: isSelected
                      ? context.primary
                      : context.currentRoleCardIcon,
                ),
                SizedBox(height: 5.h),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? context.primary
                        : context.currentRoleCardText,
                  ),
                ),
              ],
            ),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: context.currentBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.currentAppBarBackground,
        elevation: 0,
        title: Text(
          "Create Account",
          style: TextStyle(color: context.currentAppBarTitleColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: 0.5,
              backgroundColor: context.currentDividerColor,
              valueColor: AlwaysStoppedAnimation<Color>(context.primary),
              minHeight: 5.h,
            ),
            Text(
              "1/2",
              style: TextStyle(
                fontSize: 12.sp,
                color: context.currentTextSecondary,
              ),
            ),
            SizedBox(height: 20.h),
            Image.asset('assets/images/appLogo.png', height: 160.h),
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
            Obx(() {
              return controller.phoneErrorMessage.value.isNotEmpty
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 15.w, top: 5.h),
                      child: Text(
                        controller.phoneErrorMessage.value,
                        style: TextStyle(color: context.error, fontSize: 12.sp),
                      ),
                    )
                  : SizedBox(height: 5.h);
            }),
            SizedBox(height: 20.h),
            CustomTextField(
              name: 'Password',
              hint: 'Enter your password (min 8 characters)',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              controller: controller.passwordController,
              inputType: TextInputType.visiblePassword,
            ),
            Obx(() {
              return controller.passwordErrorMessage.value.isNotEmpty
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 15.w, top: 5.h),
                      child: Text(
                        controller.passwordErrorMessage.value,
                        style: TextStyle(color: context.error, fontSize: 12.sp),
                      ),
                    )
                  : SizedBox(height: 5.h);
            }),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () {
                controller.validatePhoneNumber();
                controller.validatePassword();

                if (!controller.isFormValid) {
                  Get.snackbar(
                    "Error",
                    "Please select a role and ensure all fields are valid.",
                    snackPosition: SnackPosition.TOP,
                  );
                  return;
                }

                Get.toNamed(
                  Routes.secondRegister,
                  arguments: {
                    'role': controller.selectedRole.value,
                    'mobile': controller.mobileController.text.trim(),
                    'password': controller.passwordController.text,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.currentButtonPrimary,
                minimumSize: Size(double.infinity, 55.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                "Next",
                style: TextStyle(
                  color: context.currentButtonPrimaryText,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
