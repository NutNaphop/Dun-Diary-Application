import 'package:flutter/material.dart';

class StatIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  final Widget icon;

  const StatIcon({
    super.key,
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      child: icon,
    );
  }
}
