import 'dart:io';

import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/data/blood_pressure/model/bp_record.dart';
import 'package:dun_diary_app/feature/main/presentation/main_screen.dart';
import 'package:dun_diary_app/feature/record/presentation/record_screen.dart';
import 'package:dun_diary_app/feature/record/presentation/resultScreen/result_screen.dart';
import 'package:dun_diary_app/feature/setting/presentation/profileEditScreen/profile_edit_screen.dart';
import 'package:dun_diary_app/feature/setting/presentation/profileSettingScreen/profile_setting_screen.dart';
import 'package:dun_diary_app/feature/splash_screen/presentation/splash_screen.dart';
import 'package:dun_diary_app/shared/widgets/ui/page/mock_page.dart';
import 'package:flutter/material.dart';

import '../constant/app_routes.dart';

class AppRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    AppLogger.debug('Navigate to: ${settings.name}');
    final args = settings.arguments;

    if (settings.name == AppRoutes.splash) {
      return _buildRoute(const SplashScreen());
    } else if (settings.name == AppRoutes.main) {
      return _buildRoute(const MainScreen());
    } else if (settings.name == AppRoutes.record) {
      if (args is BPRecord) {
        return _buildRoute(RecordScreen.createWithRecord(args));
      }
      return _buildRoute(RecordScreen.create());
    } else if (settings.name == AppRoutes.mock) {
      if (args != null) {
        AppLogger.debug("args: ${args.toString()}");
      }
      return _buildRoute(const MockPage());
    } else if (settings.name == AppRoutes.result) {
      if (args is File) {
        return MaterialPageRoute(
          builder: (_) => ResultScreen.createWithArg(args),
        );
      }
      return _errorRoute("Need image for this page");
    } else if (settings.name == AppRoutes.history) {
      return _errorRoute('History route not implemented yet');
    } else if (settings.name == AppRoutes.setting.recovery) {
      return _errorRoute('Recovery screen coming soon');
    } else if (settings.name == AppRoutes.setting.tutorial) {
      return _buildRoute(Center(child: Text("This is Tutorial Screen")));
    } else if (settings.name == AppRoutes.setting.profile) {
      return _buildRoute(ProfileSettingScreen.create());
    } else if (settings.name == AppRoutes.setting.profileEdit) {
      return _buildRoute(ProfileEditScreen.create());
    } else {
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
