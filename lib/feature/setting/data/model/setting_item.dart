import 'package:flutter/material.dart';

class SettingItem {
  final String title;
  final String? svgPath;
  final IconData? iconData;
  final String? route;
  final VoidCallback? onTap;
  final String? trailingIconPath;

  SettingItem({
    required this.title,
    this.svgPath,
    this.iconData,
    this.route,
    this.onTap,
    this.trailingIconPath,
  });
}
