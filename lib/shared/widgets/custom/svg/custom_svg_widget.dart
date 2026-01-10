import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SVGImage extends StatelessWidget {
  final String path;
  final double? size;
  final Color? color;

  const SVGImage({
    super.key,
    required this.path,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}

class IconButtonSVG extends StatelessWidget {
  final String path;
  final double? size;
  final Color? color;
  final VoidCallback? onPressed;

  const IconButtonSVG({
    super.key,
    required this.path,
    this.size = 24,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SVGImage(path: path, size: size, color: color),
      onPressed: onPressed,
    );
  }
}
