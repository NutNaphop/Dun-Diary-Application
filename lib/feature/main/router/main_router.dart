import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/router/base_feature_router.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/feature/main/presentation/main_screen.dart';
import 'package:dun_diary_app/feature/splash_screen/presentation/splash_screen.dart';
import 'package:dun_diary_app/shared/widgets/ui/page/mock_page.dart';
import 'package:flutter/material.dart';

class MainRouter extends BaseFeatureRouter {
  @override
  Map<String, Widget Function(dynamic args)> get routes => {
    AppRoutes.splash: (_) => SplashScreen.create(),
    AppRoutes.main: (_) => const MainScreen(),
    AppRoutes.mock: (args) {
      if (args != null) {
        AppLogger.debug("args: ${args.toString()}");
      }
      return const MockPage();
    },
  };
}
