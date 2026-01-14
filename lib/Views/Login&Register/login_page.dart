import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:house_rental_app/Components/custom_text_field.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/core/controllers/auth_controller.dart';
import 'package:house_rental_app/core/controllers/login_controller.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';
import 'package:house_rental_app/routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());
    final authC = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50.h),
              Center(
                child: SizedBox(
                  height: 150.h,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/loginimage.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: context.currentTextPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Sign in to continue ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: context.currentTextSecondary,
                ),
              ),
              SizedBox(height: 40.h),
              Obx(
                () => CustomTextField(
                  name: 'Phone Number',
                  hint: 'Ex: 9xx xxx xxx',
                  prefixIcon: Icons.phone_android,
                  inputType: TextInputType.phone,
                  controller: loginController.mobileController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 10,
                  errorText: loginController.phoneError.value.isEmpty
                      ? null
                      : loginController.phoneError.value,
                ),
              ),
              Obx(
                () => CustomTextField(
                  name: 'Password',
                  hint: 'Enter your password',
                  prefixIcon: Icons.lock_outline,
                  inputType: TextInputType.text,
                  obscureText: true,
                  controller: loginController.passwordController,
                  errorText: loginController.passwordError.value.isEmpty
                      ? null
                      : loginController.passwordError.value,
                ),
              ),
              SizedBox(height: 40.h),
              ElevatedButton(
                onPressed: () async {
                  loginController.validateFields();

                  if (loginController.phoneError.value.isNotEmpty ||
                      loginController.passwordError.value.isNotEmpty) {
                    return;
                  }

                  String phone = loginController.mobileController.text.trim();
                  String password = loginController.passwordController.text;

                  Get.dialog(
                    const Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );
                  bool success = await authC.login(phone, password);
                  Get.back();
                  if (success) {
                    Get.offAllNamed(Routes.main);
                  } else {
                    Get.snackbar(
                      'Login Failed',
                      'Invalid mobile or password, or Account not approved.',
                      snackPosition: SnackPosition.TOP,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.currentButtonPrimary,
                  minimumSize: Size(double.infinity, 55.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: context.currentButtonPrimaryText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  Expanded(child: Divider(color: context.currentDividerColor)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: context.currentTextSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: context.currentDividerColor)),
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: context.currentTextSecondary,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.register);
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: context.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
