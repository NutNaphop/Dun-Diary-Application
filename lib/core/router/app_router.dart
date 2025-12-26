import 'package:dun_diary_app/feature/main/presentation/main_screen.dart';
import 'package:dun_diary_app/shared/widgets/page/mock_page.dart';
import 'package:flutter/material.dart';

import '../constant/app_routes.dart';

class AppRouter {
  
  static Route<dynamic> generate(RouteSettings settings) {
    // 1. Debugging: ปริ้นท์ดูหน่อยว่ากำลังจะไปหน้าไหน
    print('Navigate to: ${settings.name}');

    // 2. Arguments: ดึงค่าที่ส่งมาเตรียมไว้ (เผื่อใช้)
    final args = settings.arguments;

    switch (settings.name) {
      
      // --- Case 1: หน้าปกติ ไม่รับค่า ---
      case AppRoutes.main:
        return _buildRoute(const Scaffold(body: Center(child: MainScreen()))); 

      case AppRoutes.record:
        return _buildRoute(const Scaffold(body: Center(child: MockPage())));

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
  static MaterialPageRoute _buildRoute(Widget screen) {
    return MaterialPageRoute(builder: (_) => screen);
  }

  // Error Page: หน้าแจ้งเตือนเวลาหลงทาง
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(builder: (_) {
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
    });
  }
}