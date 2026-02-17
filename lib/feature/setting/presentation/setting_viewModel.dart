import 'package:dun_diary_app/core/services/app_logger.dart';
import 'package:dun_diary_app/feature/setting/data/model/setting_item.dart';
import 'package:dun_diary_app/feature/setting/data/model/setting_section.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:flutter/material.dart';

class SettingViewmodel extends ChangeNotifier {
  List<SettingSection> get menuSections => [
    // Backup Section
    SettingSection(
      items: [
        SettingItem(
          title: 'การสำรองข้อมูลและกู้คืนข้อมูล',
          icon: SVGImage(
            path: AppIcons.duotone.note,
            width: 28,
            height: 28,
            color: CustomColor.gray400,
          ),
          onTap: () => AppLogger.debug('Restore tapped'),
        ),
        SettingItem(
          title: 'วิธีการใช้งาน',
          icon: SVGImage(
            path: AppIcons.duotone.infoCircle,
            width: 28,
            height: 28,
            color: CustomColor.gray400,
          ),
          onTap: () => AppLogger.debug('Usage Guide tapped'),
        ),
      ],
    ),
  ];
}
