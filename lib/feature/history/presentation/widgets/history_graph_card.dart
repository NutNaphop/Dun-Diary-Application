import 'package:dun_diary_app/feature/history/presentation/history_viewmodel.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/utils/date_utils.dart';
import 'package:dun_diary_app/shared/widgets/custom/card/custom_card.dart';
import 'package:dun_diary_app/shared/widgets/ui/bp_graph_sdk/bp_graph_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryGraphCard extends StatelessWidget {
  final double graphHeight;
  final EdgeInsets? contentPadding;

  const HistoryGraphCard({
    super.key,
    this.graphHeight = 343,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoryViewmodel>();

    return CustomCard(
      title: DateTimeUtils.formatToThaiDateFull(vm.selectedDate),
      titleFontSize: Dimension.fontSizes.h2,
      contentPadding: contentPadding ?? const EdgeInsets.all(20),
      content: Container(
        height: graphHeight,
        margin: const EdgeInsets.only(top: 10),
        child: BpGraphSdk(
          data: vm.selectedDateGraphData,
          onButtonPress: vm.redirectToRecord,
        ),
      ),
    );
  }
}
