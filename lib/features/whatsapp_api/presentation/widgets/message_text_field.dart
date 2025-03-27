import 'package:flutter/material.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';

class MessageTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value) onChanged;
  final VoidCallback onTapSuffix;
  const MessageTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onTapSuffix,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: TextField(
        controller: controller,
        onChanged: (value) {
          onChanged(value);
        },
        maxLines: 5,
        minLines: 1,
        decoration: InputDecoration(
          hintText: 'Enter Message',
          hintMaxLines: 1,
          hintStyle: TextStyle(color: Colors.black),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 27.0),
          filled: true,
          fillColor: AppPallete.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: Colors.white),
          ),
          suffixIcon: IconButton(
            onPressed: onTapSuffix,
            icon: Icon(
              Icons.image_outlined,
            ),
          ),
        ),
      ),
    );
  }
}
