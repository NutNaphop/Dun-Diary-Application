import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/feature/record/data/model/record_model.dart';
import 'package:dun_diary_app/feature/record/presentation/widgets/bp_card/bp_card_layout.dart';
import 'package:dun_diary_app/feature/record/presentation/record_viewModel.dart';
import 'package:dun_diary_app/feature/record/presentation/widgets/demo/demo_record.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/utils/blood_pressure_utils.dart';
import 'package:dun_diary_app/shared/widgets/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/guage/guage.dart';
import 'package:dun_diary_app/shared/widgets/scaffold/custom_scaffold.dart';
import 'package:dun_diary_app/shared/widgets/scaffold/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => RecordViewmodel(),
      child: const RecordScreen(),
    );
  }

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  BloodPressure BPValue = BloodPressure(sys: 120, dia: 80, pul: 70);
  int? avgLevel = 0;

  int get level =>
      BloodPressureUtils.calculateBloodPressureLevel(BPValue.sys, BPValue.dia);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: MainAppBar(
        title: "บันทึกความดัน",
        showBack: true,
        backIconPath: AppIcons.x,
        onBackPressed: () => NavigationService.instance.goBack(),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 36),
        child: Column(
          children: [
            CustomCard(
              content: BpCardLayout(
                sys: BPValue.sys,
                dia: BPValue.dia,
                pul: BPValue.pul,
                onSysChanged: (val) => setState(() => BPValue.sys = val),
                onDiaChanged: (val) => setState(() => BPValue.dia = val),
                onPulChanged: (val) => setState(() => BPValue.pul = val),
              ),
            ),
            const SizedBox(height: 20),
            CustomCard(
              title: BloodPressureUtils.mapLevelLabel(level),
              titleFontSize: 21,
              titleTextAlign: TextAlign.center,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              content: BloodPressureGauge(
                level: BloodPressureUtils.calculateBloodPressureLevel(
                  BPValue.sys,
                  BPValue.dia,
                ),
                avgLevel: avgLevel,
              ),
            ),
            DemoRecord(
              currentAvgLevel: avgLevel,
              onBPValset: (val) => setState(() => BPValue = val),
              onAVGValset: (val) => setState(() => avgLevel = val),
            ),
          ],
        ),
      ),
    );
  }
}
