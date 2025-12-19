import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Views/home_page.dart';
import 'package:house_rental_app/Views/landlord_apartments_page.dart';
import 'package:house_rental_app/Views/settings_page.dart';
import 'package:house_rental_app/Views/booking_page.dart';
import 'package:house_rental_app/core/controllers/navigation_controller.dart';

class MainNavigationPage extends StatelessWidget {
  MainNavigationPage({super.key});

  final List<Widget> tenantPages = [
    HomePage(),
    MyBookingsPage(),
    const SettingsPage(),
  ];

  final List<Widget> landlordPages = [
    HomePage(),
    LandlordApartmentsPage(),
    const SettingsPage(),
  ];
  final List<Widget> appBars = [
    const HomeAppBar(),
    const BookingAppBar(),
    const SettingsAppBar(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    const Color primaryBlue = Color(0xFF1E88E5);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: Obx(() => appBars[controller.selectedIndex.value]),
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
          selectedItemColor: primaryBlue,
          unselectedItemColor: Colors.grey,
          currentIndex: controller.selectedIndex.value,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                controller.isTenant ? Icons.calendar_month : Icons.apartment,
              ),
              label: controller.isTenant ? 'Bookings' : 'Apartments',
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
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
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 0,
      leading: SizedBox(
        height: 40.h,
        width: 40.w,
        child: Image.asset('assets/images/appLogo.png'),
      ),
      title: Text(
        'Welcome',
        style: TextStyle(
          color: Color(0xFF1E88E5),
          fontSize: 30.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
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
          color: Color(0xFF1E88E5),
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
          color: Color(0xFF1E88E5),
          fontSize: 30.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
