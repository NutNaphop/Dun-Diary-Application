import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/feature/setting/data/model/setting_item.dart';
import 'package:dun_diary_app/feature/setting/data/model/setting_section.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/feature/setting/data/model/tutorial_topic.dart';

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
          svgPath: AppIcons.bottomNav.userCircle,
          route: AppRoutes.setting.profileEdit,
          trailingIconPath: AppIcons.outline.pen,
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
          svgPath: AppIcons.duotone.cloudDownload,
          route: AppRoutes.setting.recoveryMyData,
          onTap: () => AppLogger.debug('Usage Guide tapped'),
        ),
      ],
    ),
  ];
}

class TurtorialMenuData {
  static List<SettingSection> get turtorialSettings => [
    SettingSection(
      items: [
        SettingItem(
          title: 'วิธีการวัดความดัน',
          description: "ขั้นตอนการใช้งานเบื้องต้น",
          svgPath: AppIcons.duotone.pen,
          iconColor: CustomColor.primaryColor,
          route: AppRoutes.setting.tutorialView,
          arguments: TutorialTopic.recordBloodPressure,
        ),
        SettingItem(
          title: 'การวิเคราะห์ข้อมูล',
          description: "ดูสรุปสถิติและกราฟแสดงแนวโน้มสุขภาพ",
          svgPath: AppIcons.fill.sparkle,
          iconColor: CustomColor.blue9,
          route: AppRoutes.setting.tutorialView,
          arguments: TutorialTopic.analyzeData,
        ),
        SettingItem(
          title: 'การดูประวัติย้อนหลัง',
          description: "ดูรายการค่าความดันที่เคยบันทึกไว้ทั้งหมด",
          svgPath: AppIcons.duotone.document,
          iconColor: CustomColor.purple4,
          route: AppRoutes.setting.tutorialView,
          arguments: TutorialTopic.history,
        ),
        SettingItem(
          title: 'การสำรองและกู้คืนข้อมูล',
          description: "ขั้นตอนการดึงข้อมูลกลับมาด้วย QR Code",
          svgPath: AppIcons.duotone.cloudDownload,
          iconColor: CustomColor.brown1,
          route: AppRoutes.setting.tutorialView,
          arguments: TutorialTopic.recoveryData,
        ),
        SettingItem(
          title: 'การส่งออกข้อมูล',
          description: "วิธีบันทึกเป็นไฟล์รูปภาพหรือไฟล์ CSV",
          svgPath: AppIcons.duotone.upload,
          iconColor: CustomColor.purple5,
          route: AppRoutes.setting.tutorialView,
          arguments: TutorialTopic.exportData,
        ),
      ],
    ),
  ];
}
