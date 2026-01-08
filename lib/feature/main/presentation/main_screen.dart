import 'package:dun_diary_app/feature/history/presentation/history_screen.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../home/presentation/home_screen.dart';
import 'main_view_model.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  // 1. กำหนดหน้าที่จะแสดงในแต่ละ Tab เรียงตามลำดับ
  List<Widget> get _pages => [
    HomeScreen.create(),
    HistoryScreen(),
    Center(child: Text("หน้าเพิ่ม")),
    Center(child: Text("หน้าสถิติ")),
    Center(child: Text("หน้าโปรไฟล์")),
  ];

  @override
  Widget build(BuildContext context) {
    // ใช้ ChangeNotifierProvider ตรงนี้เลยก็ได้ หรือจะย้ายไป Global ก็ได้
    return ChangeNotifierProvider(
      create: (_) => MainViewModel(),
      child: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            // 2. ใช้ IndexedStack เพื่อรักษาสถานะของแต่ละหน้า
            body: IndexedStack(index: viewModel.currentIndex, children: _pages),

            // เพิ่ม FloatingActionButton ตรงกลาง
            floatingActionButton: SizedBox(
              width: 50,
              height: 50,
              child: FittedBox(
                child: FloatingActionButton(
                  onPressed: () => {
                    viewModel.redirectToRecord()
                  },
                  backgroundColor: CustomColor.primaryColor,
                  shape: const CircleBorder(),
                  elevation: 4,
                  child: SvgPicture.asset(
                    'assets/icons/bottom_navigation/plus.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,

            // 3. ตัว Bottom Bar
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: viewModel.currentIndex,
              onTap: (index) => viewModel.setIndex(index),

              // สำคัญ! ถ้ามี icon มากกว่า 3 ต้อง fix type
              type: BottomNavigationBarType.fixed,

              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF8FD3D3), // สีเขียวธีมหลัก
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,

              items: [
                _buildNavItem(
                  'assets/icons/bottom_navigation/home_smile.svg',
                  "หน้าหลัก",
                ),
                _buildNavItem(
                  'assets/icons/bottom_navigation/clipboard_list.svg',
                  "รายการ",
                ),
                // เว้นว่างตรงกลางไว้สำหรับ FAB (Dummy Item)
                const BottomNavigationBarItem(
                  icon: SizedBox.shrink(),
                  label: '',
                ),
                _buildNavItem(
                  'assets/icons/bottom_navigation/chart_square.svg',
                  "สถิติ",
                ),
                _buildNavItem(
                  'assets/icons/bottom_navigation/user_circle.svg',
                  "โปรไฟล์",
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper Function เพื่อเขียน Icon ง่ายๆ (รองรับ SVG)
  BottomNavigationBarItem _buildNavItem(String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: _buildIconContent(iconPath, label, isSelected: false),
      activeIcon: _buildIconContent(iconPath, label, isSelected: true),
      label: '',
    );
  }

  Widget _buildIconContent(
    String iconPath,
    String label, {
    required bool isSelected,
  }) {
    final color = isSelected ? CustomColor.primaryColor : CustomColor.gray400;
    return Column(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        CustomText(
          text: label,
          fontSize: Dimension.fontSizes.esm ,
          fontWeight: Dimension.fontWeights.medium,
          color: color,
        ),
      ],
    );
  }
}
