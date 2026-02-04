import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimation extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final bool repeat;
  final bool animate;
  final BoxFit? fit;

  const LottieAnimation({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.repeat = true,
    this.animate = true,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      path,
      width: width,
      height: height,
      repeat: repeat,
      animate: animate,
      fit: fit,
    );
  }
}
