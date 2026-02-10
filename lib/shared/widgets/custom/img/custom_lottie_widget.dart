import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimation extends StatefulWidget {
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
  State<LottieAnimation> createState() => _LottieAnimationState();
}

class _LottieAnimationState extends State<LottieAnimation> {
  LottieComposition? _composition;

  @override
  void initState() {
    super.initState();
    _loadComposition();
  }

  @override
  void didUpdateWidget(LottieAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _loadComposition();
    }
  }

  Future<void> _loadComposition() async {
    final composition = await AssetLottie(widget.path).load();
    if (mounted) {
      setState(() => _composition = composition);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_composition == null) {
      return SizedBox(width: widget.width, height: widget.height);
    }
    return Lottie(
      composition: _composition!,
      width: widget.width,
      height: widget.height,
      repeat: widget.repeat,
      animate: widget.animate,
      fit: widget.fit,
    );
  }
}
