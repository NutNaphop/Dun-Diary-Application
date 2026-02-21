import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/data/user/repository/user_repository.dart';
import 'package:dun_diary_app/feature/splash_screen/presentation/splash_viewModel.dart';
import 'package:dun_diary_app/shared/constant/app_image.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => SplashViewModel(
        authService: context.read<AuthService>(),
        userRepository: context.read<UserRepository>(),
      ),
      child: const SplashScreen(),
    );
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    _initialization();
  }

  void _initialization() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
    FlutterNativeSplash.remove();

    if (mounted) {
      await context.read<SplashViewModel>().initializeAppData();
    }

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final viewModel = context.read<SplashViewModel>();

      if (viewModel.isRecoveryPending) {
        // Recovery ค้างอยู่ → ไปหน้า recovery เพื่อกู้ต่อ
        AppLogger.warning("⚠️ Redirecting to recovery screen...");
        NavigationService.instance.pushReplacementNamed(
          AppRoutes.setting.recoveryMyData,
        );
      } else {
        NavigationService.instance.pushReplacementNamed(AppRoutes.main);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.secondaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(seconds: 1),
              scale: _isAnimate ? 0.8 : 1.0,
              curve: Curves.easeInOut,
              child: Image.asset(AppConfigImages.logo, width: 160, height: 160),
            ),
            AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: _isAnimate ? 1.0 : 0.0,
              child: AnimatedSlide(
                duration: const Duration(seconds: 1),
                offset: _isAnimate
                    ? const Offset(0, -0.5)
                    : const Offset(0, 0.2),
                curve: Curves.easeOut,
                child: Image.asset(
                  AppConfigImages.titleLogo,
                  width: 214,
                  height: 61,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
