import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SVGImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  const SVGImage({
    super.key,
    required this.path,
    this.width = 24,
    this.height = 24,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}

class IconButtonSVG extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final Color? color;
  final VoidCallback? onPressed;

  const IconButtonSVG({
    super.key,
    required this.path,
    this.width = 24,
    this.height = 24,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SVGImage(path: path, width: width, height: height, color: color),
      onPressed: onPressed,
    );
  }
}
