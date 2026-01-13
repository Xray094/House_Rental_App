import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Views/home_page.dart';
import 'package:house_rental_app/Views/landlord_apartments_page.dart';
import 'package:house_rental_app/Views/settings_page.dart';
import 'package:house_rental_app/Views/booking_page.dart';
import 'package:house_rental_app/Views/favorites_page.dart';
import 'package:house_rental_app/core/controllers/home_controller.dart';
import 'package:house_rental_app/core/controllers/navigation_controller.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';

class MainNavigationPage extends StatelessWidget {
  MainNavigationPage({super.key});

  final List<Widget> tenantPages = [
    HomePage(),
    BookingPage(),
    FavoritesPage(),
    const SettingsPage(),
  ];

  final List<Widget> landlordPages = [
    HomePage(),
    LandlordApartmentsPage(),
    const SettingsPage(),
  ];
  final List<Widget> tenantAppBars = [
    const HomeAppBar(),
    const BookingAppBar(),
    const FavoritesAppBar(),
    const SettingsAppBar(),
  ];

  final List<Widget> landlordAppBars = [
    const HomeAppBar(),
    const LandlordApartmentAppBar(),
    const SettingsAppBar(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      backgroundColor: context.currentBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: Obx(
          () => controller.isTenant
              ? tenantAppBars[controller.selectedIndex.value]
              : landlordAppBars[controller.selectedIndex.value],
        ),
      ),

      body: Obx(() {
        if (controller.user.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return controller.isTenant
            ? tenantPages[controller.selectedIndex.value]
            : landlordPages[controller.selectedIndex.value];
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: controller.changeIndex,
          selectedItemColor: context.currentBottomNavigationBarSelected,
          unselectedItemColor: context.currentBottomNavigationBarUnselected,
          currentIndex: controller.selectedIndex.value,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            if (controller.isTenant) ...[
              const BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Bookings',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
            ] else ...[
              const BottomNavigationBarItem(
                icon: Icon(Icons.apartment),
                label: 'Apartments',
              ),
            ],
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return AppBar(
      backgroundColor: context.currentAppBarBackground,
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 0,
      leadingWidth: 62.w,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10, top: 8),
        child: SizedBox(
          height: 30.h,
          width: 30.w,
          child: Image.asset('assets/images/appLogo.png'),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Text(
          'Home',
          style: TextStyle(
            color: context.currentAppBarTitleColor,
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: Obx(
            () => IconButton(
              onPressed: controller.toggleFilters,
              icon: Icon(
                controller.isFiltersVisible.value
                    ? Icons.keyboard_arrow_up
                    : Icons.filter_list,
                color: context.currentAppBarTitleColor,
                size: 28.sp,
              ),
              tooltip: controller.isFiltersVisible.value
                  ? 'Hide Filters'
                  : 'Show Filters',
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Settings',
        style: TextStyle(
          color: context.currentAppBarTitleColor,
          fontSize: 30.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class BookingAppBar extends StatelessWidget {
  const BookingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Booking',
        style: TextStyle(
          color: context.currentAppBarTitleColor,
          fontSize: 30.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class LandlordApartmentAppBar extends StatelessWidget {
  const LandlordApartmentAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.currentAppBarBackground,
      centerTitle: true,
      elevation: 0,
      title: Text(
        'My Apartments',
        style: TextStyle(
          color: context.currentAppBarTitleColor,
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class FavoritesAppBar extends StatelessWidget {
  const FavoritesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Favorites',
        style: TextStyle(
          color: context.currentAppBarTitleColor,
          fontSize: 30.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
