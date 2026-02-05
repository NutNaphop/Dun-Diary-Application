import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/ui/tab_bar/tab_item.dart';
import 'package:flutter/material.dart';

class AppTabBar extends StatelessWidget {
  final List<String> titles; // รายชื่อแท็บที่ต้องการแสดง
  final List<Widget>? tabViews; // เนื้อหาของแต่ละแท็บ (Optional)
  final ValueChanged<int>? onTap; // Callback เมื่อมีการกดเปลี่ยนแท็บ

  const AppTabBar({super.key, required this.titles, this.tabViews, this.onTap})
    : assert(
        tabViews == null || titles.length == tabViews.length,
        'จำนวน titles และ tabViews ต้องเท่ากัน',
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: titles.length,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
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
              ),
              labelColor: CustomColor.accentColor,
              unselectedLabelColor: CustomColor.gray400,
              tabs: titles.map((title) => TabItem(title: title)).toList(),
            ),
          ),
          if (tabViews != null)
            Expanded(child: TabBarView(children: tabViews!)),
        ],
      ),
    );
  }
}
