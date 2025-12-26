import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:house_rental_app/core/bindings/app_binding.dart';
import 'package:house_rental_app/core/config/di.dart';
import 'package:house_rental_app/core/controllers/theme_controller.dart';
import 'package:house_rental_app/routes/app_pages.dart';
import 'package:house_rental_app/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final box = await setup();
  Get.put<GetStorage>(box, permanent: true);

  // Initialize theme controller
  Get.put<ThemeController>(ThemeController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return Obx(() {
          final themeController = ThemeController.to;
          return GetMaterialApp(
            initialRoute: Routes.splash,
            initialBinding: AppBinding(),
            debugShowCheckedModeBanner: false,
            title: 'House Rental',
            theme: themeController.lightTheme,
            darkTheme: themeController.darkTheme,
            themeMode: themeController.themeMode,
            getPages: AppPages.pages,
          );
        });
      },
      child: const SizedBox(),
    );
  }
}
