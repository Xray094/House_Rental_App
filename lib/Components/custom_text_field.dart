import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';

class CustomTextField extends StatelessWidget {
  final String name;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final String? errorText;
  const CustomTextField({
    super.key,

    required this.name,
    required this.prefixIcon,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.hint = "",
    required this.inputType,
    required this.controller,
    this.inputFormatters,
    this.maxLength,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        enabled: true,
        textCapitalization: textCapitalization,
        obscureText: obscureText,
        keyboardType: inputType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        textAlign: TextAlign.start,
        style: TextStyle(color: context.currentTextPrimary, fontSize: 16),
        cursorColor: context.currentTextPrimary,

        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          prefixIcon: Icon(prefixIcon, color: context.currentTextSecondary),
          isDense: true,
          labelText: name,
          hintText: hint,
          hintStyle: TextStyle(color: context.currentTextHint, fontSize: 16),
          counterText: "",
          labelStyle: TextStyle(color: context.currentTextPrimary),
          errorText: errorText,
          errorStyle: TextStyle(color: context.error, fontSize: 12),
          filled: true,
          fillColor: context.currentInputFillColor,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.currentInputBorderColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.currentInputFocusedBorderColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.currentInputBorderColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.error, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
