import 'package:flutter/material.dart';
import 'package:house_rental_app/core/config/di.dart';
import 'package:house_rental_app/Models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = sl<UserModel>();
    final attr = user.attributes;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 50.h),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: 175.h,
                width: 200.w,
                child: ClipOval(
                  child: Image.network(
                    attr.avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.image_not_supported)),
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
        ),
      ),
    );
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
}
