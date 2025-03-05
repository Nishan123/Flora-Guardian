import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  final String hintText;
  final String text;
  final bool enabled;

  const ProfileTextField({
    super.key,
    required this.hintText,
    required this.text,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: text,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: hintText,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          disabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
