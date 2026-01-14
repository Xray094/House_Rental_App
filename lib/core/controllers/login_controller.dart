import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxString phoneError = ''.obs;
  final RxString passwordError = ''.obs;

  void validateFields() {
    String phone = mobileController.text.trim();
    String password = passwordController.text;

    phoneError.value = '';
    passwordError.value = '';

    if (phone.isEmpty) {
      phoneError.value = 'Please enter your phone number';
    } else if (phone.length < 10) {
      phoneError.value = 'Phone number must be exactly 10 digits';
    }

    if (password.isEmpty) {
      passwordError.value = 'Please enter your password';
    } else if (password.length < 8) {
      passwordError.value = 'Password must be at least 8 characters';
    }
  }
}
