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

  // Validation state variables
  var isPhoneValid = false.obs;
  var isPasswordValid = false.obs;
  var phoneErrorMessage = ''.obs;
  var passwordErrorMessage = ''.obs;

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();

  var selectedDate = Rxn<DateTime>();
  var profileImage = Rxn<File>();
  var idImage = Rxn<File>();
  var isLoading = false.obs;

  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Add listeners for real-time validation
    mobileController.addListener(validatePhoneNumber);
    passwordController.addListener(validatePassword);
  }

  @override
  void onClose() {
    // Remove listeners when controller is disposed
    mobileController.removeListener(validatePhoneNumber);
    passwordController.removeListener(validatePassword);
    mobileController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }

  // Validation methods
  void validatePhoneNumber() {
    String phone = mobileController.text.trim();

    // Remove all non-digit characters for validation
    String digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      isPhoneValid.value = false;
      phoneErrorMessage.value = '';
    } else if (digitsOnly.length != 10) {
      isPhoneValid.value = false;
      phoneErrorMessage.value = 'Phone number must be exactly 10 digits';
    } else {
      isPhoneValid.value = true;
      phoneErrorMessage.value = '';
    }
  }

  void validatePassword() {
    String password = passwordController.text;

    if (password.isEmpty) {
      isPasswordValid.value = false;
      passwordErrorMessage.value = '';
    } else if (password.length < 8) {
      isPasswordValid.value = false;
      passwordErrorMessage.value = 'Password must be at least 8 characters';
    } else {
      isPasswordValid.value = true;
      passwordErrorMessage.value = '';
    }
  }

  bool get isFormValid {
    return selectedRole.value != null &&
        isPhoneValid.value &&
        isPasswordValid.value;
  }

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
