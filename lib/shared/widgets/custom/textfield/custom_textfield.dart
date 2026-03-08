import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool
  restrictSpecialChars; // Block special chars (Allow only Thai, Eng, Num, Space)
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.keyboardType,
    this.controller,
    this.validator,
    this.maxLength,
    this.inputFormatters,
    this.restrictSpecialChars = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    // Merge custom formatters with built-in ones
    final List<TextInputFormatter> formatters = [
      if (inputFormatters != null) ...inputFormatters!,
      if (restrictSpecialChars)
        FilteringTextInputFormatter.allow(
          RegExp(r'[a-zA-Z0-9\u0E00-\u0E7F\s]'), // Thai + Eng + Num + Space
        ),
    ];

    return TextFormField(
      controller: controller,
      validator: validator,
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: formatters,
      style: TextStyle(color: CustomColor.gray900, fontFamily: "NotoSanThai"),
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffixIcon,
        counterText:
            "", // Hide default counter "0/100" (Optional, usually cleaner)
        labelStyle: TextStyle(
          fontFamily: "NotoSanThai",
          color: CustomColor.gray500,
          fontSize: Dimension.fontSizes.h1,
        ),
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
