import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/feature/setting/data/model/setting_item.dart';
import 'package:dun_diary_app/feature/setting/data/model/setting_section.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';

class SettingMenuData {
  static List<SettingSection> get mainSettings => [
    SettingSection(
      items: [
        SettingItem(
          title: 'การสำรองข้อมูลและกู้ข้อมูล',
          svgPath: AppIcons.duotone.note,
          route: AppRoutes.setting.recovery,
          onTap: () => AppLogger.debug('Backup tapped'),
        ),
        SettingItem(
          title: 'วิธีการใช้งาน',
          svgPath: AppIcons.duotone.infoCircle,
          route: AppRoutes.setting.tutorial,
          onTap: () => AppLogger.debug('Usage Guide tapped'),
        ),
      ],
    ),
  ];

  static List<SettingSection> get profileSettings => [
    SettingSection(
      items: [
        SettingItem(
          title: 'แก้ไขโปรไฟล์',
          svgPath: AppIcons.duotone.note,
          route: AppRoutes.setting.profileEdit,
        ),
      ],
    ),
  ];
}

class RecoveryMenuData {
  static List<SettingSection> get recoverySettings => [
    SettingSection(
      items: [
        SettingItem(
          title: 'QR Code ของฉัน',
          svgPath: AppIcons.duotone.qrcode,
          route: AppRoutes.setting.myQrcode,
          onTap: () => AppLogger.debug('Backup tapped'),
        ),
        SettingItem(
          title: 'กู้คืนข้อมูลของฉัน',
          svgPath: AppIcons.bottomNav.userCircle,
          route: AppRoutes.setting.tutorial,
          onTap: () => AppLogger.debug('Usage Guide tapped'),
        ),
      ],
    ),
  ];
}
