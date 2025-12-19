import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:house_rental_app/Views/home_page.dart';
import 'package:house_rental_app/Views/settings_page.dart';

class MainNavigationPage extends StatefulWidget {
  MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  final Color primaryBlue = const Color(0xFF1E88E5);

  final List<Widget> pages = [
    HomePage(),
    Center(child: Text('Bookings Page')),
    SettingsPage(),
  ];
  int selectedIndex = 0;

  final List<Widget> appBars = [
    const HomeAppBar(),
    BookingAppBar(),
    SettingsAppBar(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: selectedIndex == 0
          ? const PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: HomeAppBar(),
            )
          : null,

      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
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
    return PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: SizedBox(),
    );
  }
}

class BookingAppBar extends StatelessWidget {
  const BookingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: SizedBox(),
    );
  }
}
