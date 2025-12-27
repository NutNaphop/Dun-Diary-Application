import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/feature/record/presentation/widgets/bp_card/bp_card_layout.dart';
import 'package:dun_diary_app/feature/record/presentation/record_viewModel.dart';
import 'package:dun_diary_app/shared/constant/app_icons.dart';
import 'package:dun_diary_app/shared/widgets/card/custom_card.dart';
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
  Map BPValue = {
    "SYS": 120,
    "DIA": 80,
    "PUL": 70,
  };

  void _changeNumber() {
    setState(() {
      BPValue["SYS"] = 130;
      BPValue["DIA"] = 90;
      BPValue["PUL"] = 80;
    });
  }

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
        padding: const EdgeInsets.only(top: 36),
        child: Column(children: [
          CustomCard(
            content: BpCardLayout(
              sys: BPValue["SYS"],
              dia: BPValue["DIA"],
              pul: BPValue["PUL"],
              onSysChanged: (val) => setState(() => BPValue["SYS"] = val),
              onDiaChanged: (val) => setState(() => BPValue["DIA"] = val),
              onPulChanged: (val) => setState(() => BPValue["PUL"] = val),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _changeNumber,
            child: const Text("Set Default (130/90/80)"),
          )
        ]),
      ),
    );
  }
}
