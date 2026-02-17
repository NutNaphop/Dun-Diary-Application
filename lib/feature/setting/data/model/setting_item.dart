import 'package:flutter/material.dart';

class SettingItem {
  final String title;
  final Widget? icon;
  final String? route;
  final VoidCallback? onTap;
  final String? trailingText;

  SettingItem({
    required this.title,
    this.icon,
    this.route,
    this.onTap,
    this.trailingText,
  });
}
