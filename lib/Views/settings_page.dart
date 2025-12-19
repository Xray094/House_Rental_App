import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/core/controllers/settings_controller.dart';
import 'package:house_rental_app/routes/app_routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Personal Info'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Get.toNamed(Routes.profile);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.black),
                ),
                content: const Text(
                  "Are you sure you want to logout?",
                  style: TextStyle(color: Colors.black),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final SettingsController ctrl =
                          Get.find<SettingsController>();
                      Get.dialog(
                        const Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );
                      final success = await ctrl.logout();
                      Get.back();
                      if (success) {
                        Get.offAllNamed(Routes.login);
                      } else {
                        Get.snackbar('Error', 'Logout failed');
                      }
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
