import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isHome;      // เป็นหน้า Home (หัวเขียว) หรือไม่
  final bool showBack;    // (เพิ่ม) บังคับโชว์/ซ่อน ปุ่ม Back
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  const MainAppBar({
    super.key,
    this.title,
    this.isHome = false,
    this.showBack = true, // Default คือให้โชว์ (สำหรับหน้าย่อยส่วนใหญ่)
    this.actions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isHome) {
      return AppBar(
        automaticallyImplyLeading: false, 
        toolbarHeight: 100,
        backgroundColor: CustomColor.secondaryColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(text: "สวัสดี" , fontSize: 12, fontWeight: Dimension.fontWeightRegular,color: CustomColor.gray900,),
                    CustomText(text: title ?? "คุณ...", fontSize: 14, fontWeight: Dimension.fontWeightRegular, color: CustomColor.gray900,),
                  ],
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      );
    }

    return AppBar(
      automaticallyImplyLeading: showBack, 
      
      // ถ้ามีการส่ง onBackPressed มา จะ Override ปุ่ม Back เดิม
      leading: showBack && onBackPressed != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: onBackPressed,
            )
          : null, // ปล่อยให้เป็น null เพื่อให้ automatic ทำงาน (หรือซ่อนไปเลย)

      title: CustomText(
        text: title ?? "",
        fontSize: Dimension.fontSizeHeading2,
        fontWeight: Dimension.fontWeightSemiBold,
      ),
      backgroundColor: Colors.transparent, // หรือ Colors.white
      elevation: 0,
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: const IconThemeData(color: Colors.black), // ทำให้ปุ่ม Back อัตโนมัติเป็นสีดำ
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(isHome ? 100 : kToolbarHeight);
}