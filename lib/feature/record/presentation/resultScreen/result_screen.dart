import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/drop_shadow.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/stat_row.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/custom/scaffold/main_appbar.dart';
import 'package:dun_diary_app/shared/widgets/custom/svg/custom_svg_widget.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: MainAppBar(
        title: "บันทึกความดัน",
        showBack: true,
        onBackPressed: () => NavigationService.instance.goBack(),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 33),
        child: Column(
          spacing: 21,
          children: [
            Container(
              width: double.infinity,
              height: 272,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CustomColor.gray300,
                boxShadow: [DropShadow.drop_popup],
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            CustomCard(
              contentPadding: EdgeInsets.all(10),
              content: Column(
                children: [
                  StatRow(
                    leading: SVGImage(
                      path: AppIcons.duotone.graphUp,
                      size: 34,
                      color: CustomColor.purple1,
                    ),
                    label: 'SYS',
                    description: 'ความดันโลหิตขณะหัวใจบีบตัว',
                    value: '115',
                  ),
                  StatRow(
                    leading: SVGImage(
                      path: AppIcons.duotone.graphDown,
                      size: 34,
                      color: CustomColor.blue1,
                    ),
                    label: 'DIA',
                    description: 'ความดันโลหิตขณะหัวใจคลายตัว',
                    value: '75',
                  ),
                  StatRow(
                    leading: SVGImage(
                      path: AppIcons.duotone.heartPulse,
                      size: 34,
                      color: CustomColor.pink1,
                    ),
                    label: 'PUL',
                    description: 'อัตราการเต้นของหัวใจ',
                    value: '72',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
