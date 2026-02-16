import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? height;
  final double? width;

  const CustomBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 10, 20, 30),
    this.height,
    this.width,
  });

  // Helper Function สำหรับเรียกใช้ง่ายๆ
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    double? height,
    double? width,
    EdgeInsetsGeometry? padding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomBottomSheet(
        title: title,
        height: height,
        width: width,
        padding: padding ?? const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height, // ถ้าส่งมาจะใช้ค่านี้ ถ้าไม่ส่งจะเป็น null (auto)
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // หดความสูงเท่าที่จำเป็น
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Drag Handle (ขีดเทาๆ ด้านบน)
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: CustomColor.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // 2. Title (ถ้ามีส่งมา)
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: CustomText(
                text: title!,
                fontSize: Dimension.fontSizes.h2, // ปรับขนาดตาม Design System
                fontWeight: Dimension.fontWeights.bold,
                color: CustomColor.gray900,
              ),
            ),

          // 3. Content (เนื้อหาที่จะเปลี่ยนไปเรื่อยๆ)
          Flexible(
            child: Padding(
              padding: padding,
              // ใช้ SingleChildScrollView เผื่อเนื้อหายาวเกินหน้าจอจะได้เลื่อนได้
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: child,
              ),
            ),
          ),

          // กันพื้นที่ SafeArea ด้านล่าง (สำหรับ iPhone จอแหว่ง)
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
