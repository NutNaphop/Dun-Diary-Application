import 'package:dun_diary_app/shared/style/color.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.keyboardType,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16, color: CustomColor.gray900),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: CustomColor.gray500),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: CustomColor.gray400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: CustomColor.blue4, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: CustomColor.red4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: CustomColor.red4, width: 2),
        ),
      ),
    );
  }
}
