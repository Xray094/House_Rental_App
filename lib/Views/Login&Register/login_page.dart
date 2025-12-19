import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:house_rental_app/Components/custom_text_field.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/core/controllers/auth_controller.dart';
import 'package:house_rental_app/routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  static const Color primaryBlue = Color(0xFF1E88E5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50.h),
              Center(
                child: Container(
                  height: 150.h,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/loginimage.jpg",
                    fit: BoxFit.fill,
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
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Sign in to continue ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 40.h),
              CustomTextField(
                name: 'Phone Number',
                hint: 'Ex: 9xx xxx xxx',
                prefixIcon: Icons.phone_android,
                inputType: TextInputType.phone,
                controller: mobileController,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                name: 'Password',
                hint: 'Enter your password',
                prefixIcon: Icons.lock_outline,
                inputType: TextInputType.text,
                obscureText: true,
                controller: passwordController,
              ),
              SizedBox(height: 40.h),
              ElevatedButton(
                onPressed: () async {
                  final authC = Get.find<AuthController>();
                  Get.dialog(
                    const Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );
                  bool success = await authC.login(
                    mobileController.text,
                    passwordController.text,
                  );
                  Get.back();
                  if (success) {
                    Get.offAllNamed(Routes.main);
                  } else {
                    Get.snackbar(
                      'Login Failed',
                      'Invalid mobile or password, or Account not approved.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  minimumSize: Size(double.infinity, 55.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[400])),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[400])),
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
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
                        color: primaryBlue,
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
