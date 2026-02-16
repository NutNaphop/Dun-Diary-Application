import 'package:dun_diary_app/feature/record/presentation/record_viewModel.dart';
import 'package:dun_diary_app/feature/record/presentation/widgets/bp_card/bp_card_layout.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordBpCard extends StatelessWidget {
  const RecordBpCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordViewmodel>(
      builder: (context, viewModel, child) {
        return CustomCard(
          content: BpCardLayout(
            sys: viewModel.bpValue.sys,
            dia: viewModel.bpValue.dia,
            pul: viewModel.bpValue.pul,
            onSysChanged: (val) => viewModel.updateSys(val),
            onDiaChanged: (val) => viewModel.updateDia(val),
            onPulChanged: (val) => viewModel.updatePul(val),
          ),
        );
      },
    );
  }
}
