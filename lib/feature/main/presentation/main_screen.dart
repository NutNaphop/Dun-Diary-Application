import 'package:dun_diary_app/feature/history/presentation/history_screen.dart';
import 'package:dun_diary_app/feature/setting/presentation/setting_screen.dart';
import 'package:dun_diary_app/feature/stat/presentation/stat_screen.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/presentation/home_screen.dart';
import 'main_view_model.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  // Helper method สำหรับสร้างหน้าตาม Index
  // วิธีนี้จะทำให้เกิดการสร้างใหม่เมื่อเปิด และ Dispose เมื่อปิดแท็บ
  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return HomeScreen.create();
      case 1:
        return HistoryScreen.create();
      case 2: // case 2 (Add Page) คือปุ่ม + ตรงกลาง ไม่มีการ render หน้า
        return const SizedBox.shrink();
      case 3:
        return StatScreen.create();
      case 4:
        return SettingScreen.create();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ใช้ ChangeNotifierProvider ตรงนี้เลยก็ได้ หรือจะย้ายไป Global ก็ได้
    return ChangeNotifierProvider(
      create: (_) => MainViewModel(),
      child: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            // 2. เปลี่ยนมาใช้การ Render เฉพาะหน้าที่เลือก
            body: _buildBody(viewModel.currentIndex),

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
                  AppIcons.bottomNav.homeSmile,
                  AppStrings.bottomNavigation.home,
                ),
                _buildNavItem(
                  AppIcons.bottomNav.clipboardList,
                  AppStrings.bottomNavigation.history,
                ),
                _buildNavItem(AppIcons.bottomNav.addSquared, null),
                _buildNavItem(
                  AppIcons.bottomNav.chartSquare,
                  AppStrings.bottomNavigation.statistic,
                ),
                _buildNavItem(
                  AppIcons.bottomNav.userCircle,
                  AppStrings.bottomNavigation.profile,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper Function เพื่อเขียน Icon ง่ายๆ (รองรับ SVG)
  BottomNavigationBarItem _buildNavItem(String iconPath, String? label) {
    if (label == null) {
      return BottomNavigationBarItem(
        icon: _buildIconContent(
          iconPath,
          isActive: false, // For plus button, we can treat it visually distinct
          isPlus: true, // Special flag for plus button
        ),
        activeIcon: _buildIconContent(iconPath, isActive: true, isPlus: true),
        label: '', // Empty label for spacing
      );
    }
    return BottomNavigationBarItem(
      icon: _buildIconContent(iconPath, label: label, isActive: false),
      activeIcon: _buildIconContent(iconPath, label: label, isActive: true),
      label: '',
    );
  }

  Widget _buildIconContent(
    String iconPath, {
    String? label,
    required bool isActive,
    bool isPlus = false,
  }) {
    if (isPlus) {
      return SVGImage(
        path: AppIcons.bottomNav.addSquared,
        width: 35,
        height: 35,
        color: CustomColor.gray400,
      );
    }

    final color = isActive ? CustomColor.primaryColor : CustomColor.gray400;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SVGImage(path: iconPath, width: 24, height: 24, color: color),
        if (label != null) ...[
          const SizedBox(height: 4),
          CustomText(
            text: label,
            fontSize: Dimension.fontSizes.esm,
            fontWeight: Dimension.fontWeights.medium,
            color: color,
          ),
        ],
      ],
    );
  }
}
