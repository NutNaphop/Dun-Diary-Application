import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class CalendarBaseCell extends StatelessWidget {
  // Data
  final String text;
  final bool isToday; // ควบคุมการโชว์จุด
  
  // Style & Color
  final Color textColor;
  final Color backgroundColor;
  final FontWeight? fontWeight;
  
  // Shape & Size
  final BoxShape shape;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry margin;  // ใช้บีบวงกลม (สำหรับ Day/Week)
  final EdgeInsetsGeometry padding; // ใช้ขยายแคปซูล (สำหรับ Month/Year)
  
  // Interaction
  final VoidCallback? onTap; // ถ้ามีค่า = กดได้, ถ้า null = แค่โชว์เฉยๆ

  // Config จุด (Offset)
  final double dotOffset; // ระยะห่างจากขอบล่าง (Offset)

  const CalendarBaseCell({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    this.isToday = false,
    this.fontWeight,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.onTap,
    this.dotOffset = 4.0, // ค่า Default ให้จุดลอยสูงจากขอบล่าง 4px
  });

  @override
  Widget build(BuildContext context) {
    // เนื้อหาข้างใน (Stack)
    Widget content = Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // --- Layer 1: พื้นหลัง (Highlight & Text) ---
        Container(
          margin: margin,     // ใช้ margin บีบวงกลม (Day)
          padding: padding,   // ใช้ padding ดันแคปซูล (Month)
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: shape,
            borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
          ),
          child: Center(
            child: FittedBox( // กันตัวหนังสือล้น
              fit: BoxFit.scaleDown,
              child: CustomText(
                text: text,
                fontSize: Dimension.fontSizes.h2,
                fontWeight: fontWeight ?? Dimension.fontWeights.medium,
                color: textColor,
              ),
            ),
          ),
        ),

        
        // --- Layer 2: จุดสีฟ้า (The Dot) ---
        if (isToday)
          Positioned(
            bottom: dotOffset, // *** ใช้ Offset ที่เรายัดเข้ามา ***
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.blueAccent, // หรือ CustomColor.blue1
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );

    // ถ้ากดได้ (Month/Year) ให้ห่อด้วย InkWell
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: content,
      );
    }

    return content;
  }
}