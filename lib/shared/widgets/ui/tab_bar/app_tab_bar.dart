import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/ui/tab_bar/tab_item.dart';
import 'package:flutter/material.dart';

class AppTabBar extends StatelessWidget {
  final List<String> titles; // รายชื่อแท็บที่ต้องการแสดง
  final List<Widget>? tabViews; // เนื้อหาของแต่ละแท็บ (Optional)
  final Widget? child; // เนื้อหาเดียวสำหรับทุกแท็บ (ใช้แทน tabViews)
  final ValueChanged<int>? onTap; // Callback เมื่อมีการกดเปลี่ยนแท็บ
  final bool shrinkWrap; // true = ใช้ intrinsic height (สำหรับ ScrollView)

  const AppTabBar({
    super.key,
    required this.titles,
    this.tabViews,
    this.child,
    this.onTap,
    this.shrinkWrap = false,
  }) : assert(
         (tabViews == null && child == null) ||
             (tabViews != null && child == null) ||
             (tabViews == null && child != null),
         'ใช้ tabViews หรือ child อย่างใดอย่างหนึ่ง ไม่ใช้พร้อมกัน',
       );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: titles.length,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: CustomColor.gray200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              onTap: onTap, // ส่งค่า index กลับไปเมื่อมีการกด
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicatorPadding: EdgeInsetsGeometry.all(4),
              indicator: BoxDecoration(
                color: CustomColor.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [DropShadow.drop_thumb],
              ),
              labelColor: CustomColor.accentColor,
              unselectedLabelColor: CustomColor.gray400,
              tabs: titles.map((title) => TabItem(title: title)).toList(),
            ),
          ),
          if (tabViews != null)
            shrinkWrap
                ? TabBarView(children: tabViews!)
                : Expanded(child: TabBarView(children: tabViews!)),
          if (child != null) shrinkWrap ? child! : Expanded(child: child!),
        ],
      ),
    );
  }
}
