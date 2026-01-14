import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/routes/app_routes.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';
import 'package:house_rental_app/core/controllers/auth_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    checkTokenAndNavigate();

    return Scaffold(
      backgroundColor: context.currentBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(child: Image.asset('assets/images/loginimage.png')),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  void checkTokenAndNavigate() async {
    await Future.delayed(const Duration(seconds: 1));

    final authController = Get.find<AuthController>();
    final isValid = await authController.validateCurrentToken();

    if (isValid) {
      Get.offNamed(Routes.main);
    } else {
      Get.offNamed(Routes.login);
    }
  }
}
