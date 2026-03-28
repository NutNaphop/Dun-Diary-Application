import 'package:flutter/material.dart';

class SettingItem {
  final String title;
  final String? description;
  final String? svgPath;
  final IconData? iconData;
  final Color? iconColor;
  final String? route;
  final Object? arguments;
  final VoidCallback? onTap;
  final String? trailingIconPath;

  SettingItem({
    required this.title,
    this.description,
    this.svgPath,
    this.iconData,
    this.iconColor,
    this.route,
    this.arguments,
    this.onTap,
    this.trailingIconPath,
  });
}
