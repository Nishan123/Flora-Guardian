import 'package:flutter/material.dart';

class SearchBarField extends StatelessWidget {
  final String hintText;
  final Icon? prefixIcon;
  final VoidCallback? onPressedPrefix;
  final TextEditingController controller;

  const SearchBarField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.onPressedPrefix,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10,top: 10),
      child: TextFormField(
        keyboardType: TextInputType.name,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: prefixIcon != null
              ? IconButton(onPressed: onPressedPrefix, icon: prefixIcon!)
              : null,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black38),
          filled: true,
          fillColor: Colors.black12,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 1,
              color: Colors.blue.withOpacity(0.2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
