import 'dart:io';

import 'package:dun_diary_app/feature/main/presentation/main_screen.dart';
import 'package:dun_diary_app/data/blood_pressure/model/record_model.dart';
import 'package:dun_diary_app/feature/record/presentation/record_screen.dart';
import 'package:dun_diary_app/feature/splash_screen/presentation/splash_screen.dart';
import 'package:dun_diary_app/feature/record/presentation/resultScreen/result_screen.dart';
import 'package:dun_diary_app/shared/widgets/ui/page/mock_page.dart';
import 'package:flutter/material.dart';

import '../constant/app_routes.dart';

class AppRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    // 1. Debugging: ปริ้นท์ดูหน่อยว่ากำลังจะไปหน้าไหน
    print('Navigate to: ${settings.name}');

    // 2. Arguments: ดึงค่าที่ส่งมาเตรียมไว้ (เผื่อใช้)
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return _buildRoute(const SplashScreen());

      // --- Case 1: หน้าปกติ ไม่รับค่า ---
      case AppRoutes.main:
        return _buildRoute(const MainScreen());

      case AppRoutes.record:
        if (args is BloodPressure) {
          return _buildRoute(RecordScreen.createWithArgs(args));
        }
        return _buildRoute(RecordScreen.create());

      case AppRoutes.mock:
        if (args != null) {
          print("args: ${args.toString()}");
        }
        return _buildRoute(const MockPage());

      case AppRoutes.result:
        if (args is File) {
          return MaterialPageRoute(
            builder: (_) => ResultScreen.createWithArg(args),
          );
        }
        return _errorRoute("Need image for this page");

      // --- Case 2: หน้าที่ต้องรับค่า (ตัวอย่าง) ---
      // สมมติหน้า Edit ต้องรับ ID (String) ไปแก้ไข
      /*
      case AppRoutes.editRecord:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => EditRecordScreen(recordId: args),
          );
        }
        return _errorRoute('Missing or Invalid ID for Edit Record');
      */

      // --- Case Default: หาไม่เจอ ---
      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  // Helper Function: ช่วยให้เขียนสั้นลง (Optional)
  static MaterialPageRoute _buildRoute(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }

  // Error Page: หน้าแจ้งเตือนเวลาหลงทาง
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 50),
                const SizedBox(height: 10),
                Text(message, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }
}
