import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final IconButton? suffixIcon;
  const AuthField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.obscureText = false,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        obscureText: obscureText,
        obscuringCharacter: '*',
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: suffixIcon,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hintText';
          }
          return null;
        });
  }
}
