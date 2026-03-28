import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/router/base_feature_router.dart';
import 'package:dun_diary_app/feature/setting/presentation/myQrCodeScreen/my_qr_code_screen.dart';
import 'package:dun_diary_app/feature/setting/presentation/profileEditScreen/profile_edit_screen.dart';
import 'package:dun_diary_app/feature/setting/presentation/profileSettingScreen/profile_setting_screen.dart';
import 'package:dun_diary_app/feature/setting/presentation/recoverySettingScreen/recovery_setting_screen.dart';
import 'package:dun_diary_app/feature/setting/presentation/recoveryMyDataScreen/recovery_my_data_screen.dart';
import 'package:dun_diary_app/feature/setting/presentation/qrScanScreen/qr_scanner_screen.dart';
import 'package:dun_diary_app/feature/setting/presentation/tutorialScreen/turtorial_screen.dart';
import 'package:dun_diary_app/feature/setting/presentation/tutorialDetailScreen/presentation/tutorial_detail_screen.dart';
import 'package:dun_diary_app/feature/setting/data/model/tutorial_topic.dart';
import 'package:flutter/material.dart';

class SettingRouter extends BaseFeatureRouter {
  @override
  Map<String, Widget Function(dynamic args)> get routes => {
    AppRoutes.setting.profile: (_) => ProfileSettingScreen.create(),
    AppRoutes.setting.profileEdit: (_) => ProfileEditScreen.create(),
    AppRoutes.setting.recovery: (_) => RecoverySettingScreen.create(),
    AppRoutes.setting.myQrcode: (_) => MyQrCodeScreen.create(),
    AppRoutes.setting.recoveryMyData: (_) => RecoveryMyDataScreen.create(),
    AppRoutes.setting.qrScanner: (_) => QrScannerScreen(),
    AppRoutes.setting.tutorial: (_) => TurtorialScreen.create(),
    AppRoutes.setting.tutorialView: (args) {
      final topic = args as TutorialTopic;
      return TutorialViewScreen.create(topic);
    },
  };
}
