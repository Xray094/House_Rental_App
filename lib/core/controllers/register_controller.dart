import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/register_model.dart';
import 'package:house_rental_app/Services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  var selectedRole = Rxn<String>();

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();

  var selectedDate = Rxn<DateTime>();
  var profileImage = Rxn<File>();
  var idImage = Rxn<File>();
  var isLoading = false.obs;

  final picker = ImagePicker();

  Future<void> pickImage(bool isProfile) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (isProfile) {
        profileImage.value = File(image.path);
      } else {
        idImage.value = File(image.path);
      }
    }
  }

  Future<void> registerUser({
    required String role,
    required String mobile,
    required String password,
  }) async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        selectedDate.value == null ||
        profileImage.value == null ||
        idImage.value == null) {
      Get.snackbar(
        "Error",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      final res = await _authService.register(
        RegisterModule(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          mobile: mobile,
          password: password,
          birthDate: selectedDate.value!,
          profileImage: profileImage.value!,
          idImage: idImage.value!,
          role: role,
        ),
      );

      if (res['success'] == true) {
        Get.offAllNamed('/login');
        Get.snackbar(
          "Success",
          res['message'] ?? "Waiting for admin approval.",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Registration Failed",
          res['message'] ?? "resgistration failed.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
