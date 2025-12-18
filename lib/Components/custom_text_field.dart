import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String name;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final TextEditingController controller;
  const CustomTextField({
    super.key,

    required this.name,
    required this.prefixIcon,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.hint = "",
    required this.inputType,
    required this.controller,
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
        textAlign: TextAlign.start,
        style: TextStyle(color: Colors.black, fontSize: 16),
        cursorColor: Colors.black,

        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          prefixIcon: Icon(prefixIcon),
          isDense: true,
          labelText: name,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          counterText: "",
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
