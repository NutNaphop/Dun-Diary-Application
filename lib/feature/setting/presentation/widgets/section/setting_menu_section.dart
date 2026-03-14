import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/feature/setting/data/model/setting_section.dart';
import 'package:dun_diary_app/feature/setting/presentation/widgets/card/menu_item.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/img/custom_svg_widget.dart';
import 'package:flutter/material.dart';

class SettingMenuSection extends StatelessWidget {
  final SettingSection section;

  const SettingMenuSection({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title != null)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              section.title!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        CustomCard(
          borderRadius: 15,
          content: Column(
            children: section.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isFirst = index == 0;
              final isLast = index == section.items.length - 1;

              BorderRadius? borderRadius;
              if (isFirst && isLast) {
                borderRadius = BorderRadius.circular(15);
              } else if (isFirst) {
                borderRadius = const BorderRadius.vertical(
                  top: Radius.circular(15),
                );
              } else if (isLast) {
                borderRadius = const BorderRadius.vertical(
                  bottom: Radius.circular(15),
                );
              }

              Widget leadingIcon = const SizedBox.shrink();
              if (item.svgPath != null) {
                leadingIcon = SVGImage(
                  path: item.svgPath!,
                  width: 28,
                  height: 28,
                  color: item.iconColor ?? CustomColor.gray400,
                );
              } else if (item.iconData != null) {
                leadingIcon = Icon(
                  item.iconData,
                  color: item.iconColor ?? CustomColor.gray400,
                  size: 28,
                );
              }

              return MenuItem(
                leadingIcon: leadingIcon,
                actionIcon: SVGImage(
                  path: item.trailingIconPath ?? AppIcons.outline.rightArrow,
                  width: 22,
                  height: 22,
                  color: CustomColor.gray900,
                ),
                title: item.title,
                description: item.description,
                onTap: () {
                  if (item.arguments != null) {
                    NavigationService.instance.pushNamed(
                      item.route!,
                      arguments: item.arguments,
                    );
                  } else if (item.route != null) {
                    NavigationService.instance.pushNamed(item.route!);
                  }
                  item.onTap?.call();
                },
                isHaveDivider: !isLast,
                borderRadius: borderRadius,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
