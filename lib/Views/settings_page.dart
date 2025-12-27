import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/core/controllers/settings_controller.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';
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
        ListTile(
          leading: Icon(Icons.dark_mode),
          title: Text('Dark Mode'),
          trailing: Switch(
            value: ThemeControllerExtensions(context).isDarkMode,
            onChanged: (value) {
              ThemeControllerExtensions(context).toggleTheme();
            },
          ),
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.logout, color: context.error),
          title: Text('Logout', style: TextStyle(color: context.error)),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: context.currentCardColor,
                title: Text(
                  "Logout",
                  style: TextStyle(color: context.currentTextPrimary),
                ),
                content: Text(
                  "Are you sure you want to logout?",
                  style: TextStyle(color: context.currentTextSecondary),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: context.currentTextSecondary),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final SettingsController ctrl =
                          Get.find<SettingsController>();
                      Get.dialog(
                        Center(
                          child: CircularProgressIndicator(
                            color: context.currentButtonPrimary,
                          ),
                        ),
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
                    child: Text(
                      "Logout",
                      style: TextStyle(color: context.error),
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
