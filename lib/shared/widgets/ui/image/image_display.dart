import 'dart:io';

import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final File? image;
  final double height;
  final double width;

  const ImageDisplay({
    super.key,
    required this.image,
    this.height = 272,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: image != null ? CustomColor.gray300 : CustomColor.transparent,
        boxShadow: image != null ? [DropShadow.drop_popup] : [],
        borderRadius: BorderRadius.circular(15),
      ),
      child: image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                image!,
                fit: BoxFit.contain,
                width: width,
                height: height,
              ),
            )
          : const _LoadingDisplay(size: 80),
    );
  }
}

class _LoadingDisplay extends StatelessWidget {
  final double size;

  const _LoadingDisplay({this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("data"));
  }
}
