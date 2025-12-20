import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/core/controllers/auth_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authCtrl = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 50.h),
        child: Obx(() {
          final user = authCtrl.user.value;
          if (user == null) {
            return const Center(child: Text('No user data available'));
          }
          final attr = user.attributes;

          return Column(
            children: [
              Center(
                child: SizedBox(
                  height: 150.r,
                  width: 150.r,
                  child: ClipOval(
                    child: Image.network(
                      attr.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.person, size: 50)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              _infoTile('Full Name', attr.fullName),
              _infoTile('Phone Number', attr.phoneNumber),
              _infoTile('Role', attr.role),
              _infoTile('Birthday', attr.birthDate),
            ],
          );
        }),
      ),
    );
  }
}

Widget _infoTile(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(value, style: const TextStyle(color: Colors.grey)),
      ],
    ),
  );
}
