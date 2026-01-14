import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Components/user_avatar.dart';
import 'package:house_rental_app/core/controllers/auth_controller.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authCtrl = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.currentAppBarBackground,
        title: Text(
          'Profile',
          style: TextStyle(color: context.currentAppBarTitleColor),
        ),
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
                child: UserAvatar(
                  name: attr.fullName,
                  imageUrl: attr.avatarUrl,
                  radius: 75,
                ),
              ),
              SizedBox(height: 20.h),
              _infoTile('Full Name', attr.fullName, context),
              _infoTile('Phone Number', attr.phoneNumber, context),
              _infoTile('Role', attr.role, context),
              _infoTile('Birthday', attr.birthDate, context),
            ],
          );
        }),
      ),
    );
  }
}

Widget _infoTile(String label, String value, BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.currentTextPrimary,
          ),
        ),
        Text(value, style: TextStyle(color: context.currentTextSecondary)),
      ],
    ),
  );
}
